#!/usr/bin/env bash

# Manage a per-project, rootless Docker engine in a dedicated Lima VM, for use
# with the nono sandbox.
#
# One VM per project directory. Its Docker socket is forwarded to a short path
# and linked from the project at .nono/d, which the nono `sandboxed-docker`
# profile grants. Run outside the sandbox: create/start/upgrade/recreate/delete
# a VM. The nono before-hook only starts an existing one and injects DOCKER_*.
#

set -euo pipefail

ACTION=""
ASSUME_YES=false
# Resolve symlinks, so a link on PATH (e.g. ~/bin/sandboxed-docker) still
# finds the template relative to the real script
SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
TEMPLATE="$SCRIPT_DIR/../lima/sandboxed-docker.yaml"
CURRENT_DIR="$(pwd -P)"
# Symlink in the project that the nono profile grants via
#   unix_socket_dir: ["$WORKDIR/.nono/d"]
# It points at the short real socket directory (REAL_SOCKET_DIR, set in main),
# so the socket's sun_path stays within the macOS limit no matter how long the
# project path is. The grant must canonicalize through this symlink.
SOCKET_LINK_DIR="$CURRENT_DIR/.nono/d"
DOCKER_CONFIG_DIR="$CURRENT_DIR/.nono/docker-config"
# Short base for the real socket
SOCKET_BASE="${XDG_RUNTIME_DIR:-/tmp}"
REAL_SOCKET_DIR=""
DOCKER_SOCKET=""
# macOS sun_path is 104 bytes including the terminating NUL
MAX_SOCKET_PATH_LEN=103

usage() {
  cat <<EOF

  $0: Manage sandboxed docker engine using Lima

  Start and stop sandboxed docker engine.
  The name of the VM will be a shorted variant of the full path to CWD.
  The CWD will be mounted to docker volume.
  The docker socket is forwarded to a short path under \$XDG_RUNTIME_DIR
  (or /tmp), and CWD/.nono/d is a symlink to it.

  Usage:
    $0 <command>

  Arguments:
    <command>           (Required) command to be run

  Commands:
    start               Create (if needed) and start a sandboxed docker mounted to CWD
    start-if-exists     Start the sandboxed VM named from CWD, only if it already exists
    stop                Stop the sandboxed VM named from CWD
    delete              Delete the sandboxed VM (loses images and volumes; keeps .nono dirs)
    status              Check status for the sandboxed VM named from CWD
    upgrade             Upgrade OS and Docker packages in the sandboxed VM and restart it
    recreate            Delete the sandboxed VM and create a fresh one (loses images and volumes)
    list-orphans        List sandboxed VMs whose project directory no longer exists
    print-env           Print docker environment variables as KEY=VALUE, if the VM is running

  Options:
    -h, --help          Show this help message.
    -y, --yes           Skip the confirmation prompt (recreate).

EOF
}

info() { echo -e "\033[0;32m[INFO]\033[0m  $1"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m  $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1" >&2; }
die() {
  error "$*"
  exit 1
}
parse_args() {
  local positional_args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    -y | --yes)
      ASSUME_YES=true
      shift 1
      ;;
    -*)
      error "Unknown option: $1"
      usage >&2
      exit 1
      ;;
    *)
      positional_args+=("$1")
      shift 1
      ;;
    esac
  done

  # Handle Positional Arguments
  local NO_OF_MANDATORY_ARGS=1
  local arg_count=${#positional_args[@]}
  if [[ "$arg_count" -lt $NO_OF_MANDATORY_ARGS ]]; then
    error "Incorrect number of arguments. Expected 1, got $arg_count." >&2
    usage >&2
    exit 1
  else
    if [[ "$arg_count" -ge 1 ]]; then
      ACTION="${positional_args[0]}"
    fi
  fi
}

prereq() {
  local tools=("limactl" "jq" "shasum")
  for tool in "${tools[@]}"; do
    command -v "$tool" >/dev/null 2>&1 ||
      die "Required tool not found: $tool"
  done
}

get_vm_status() {
  local vm_name="$1"
  limactl list --json 2>/dev/null | jq -r --arg name "$vm_name" 'select(.name==$name) | .status' || true
}

get_path_slug() {
  # max_len=76 minus socket name
  local max_len=50
  local hash_len=8
  local rel_path dir clean_dir slug="" shortened=false
  local dirs=() parts=()

  # Strip home directory
  rel_path="${CURRENT_DIR#"$HOME"/}"
  [ "$rel_path" = "$CURRENT_DIR" ] && rel_path="${CURRENT_DIR#/}"

  # Split path into array and sanitize directory names
  while [ -n "$rel_path" ]; do
    dir="${rel_path%%/*}"
    if [ -n "$dir" ]; then
      # Replace dots and non-alphanumeric chars with underscores
      clean_dir="$(printf '%s' "$dir" | tr -c 'A-Za-z0-9' '_')"
      dirs+=("$clean_dir")
    fi
    case "$rel_path" in
    */*) rel_path="${rel_path#*/}" ;;
    *) break ;;
    esac
  done

  local count=${#dirs[@]}
  [ "$count" -eq 0 ] && echo "" && return

  # Collapse all parent directories to 1 character as initial baseline
  for ((i = 0; i < count - 1; i++)); do
    parts+=("${dirs[i]:0:1}")
  done
  # Add last directory in full
  parts+=("${dirs[count - 1]}")

  # Expand parents from right to left if remaining character budget allows
  for ((i = count - 2; i >= 0; i--)); do
    parts[i]="${dirs[i]}"

    local test_slug=""
    for p in "${parts[@]}"; do
      [ -n "$test_slug" ] && test_slug="${test_slug}_$p" || test_slug="$p"
    done

    if [ ${#test_slug} -gt $max_len ]; then
      parts[i]="${dirs[i]:0:1}"
      break
    fi
  done

  # Build final slug, noting whether any directory was shortened
  for ((i = 0; i < count; i++)); do
    [ "${parts[i]}" != "${dirs[i]}" ] && shortened=true
    p="${parts[i]}"
    [ -n "$slug" ] && slug="${slug}_$p" || slug="$p"
  done

  # Cleanup to satisfy Lima identifier regex:
  #  must match ^[A-Za-z0-9]+(?:[._-](?:[A-Za-z0-9]+))*$
  slug="$(echo "$slug" | sed -E 's/_+/_/g; s/^_//; s/_$//')"


  [ ${#slug} -gt $max_len ] && shortened=true
  # Make shortened slug unique
  if [ "$shortened" = true ]; then
    local hash
    hash="$(printf '%s' "$CURRENT_DIR" | shasum -a 256 | cut -c1-"$hash_len")"
    slug="${slug:0:$((max_len - hash_len - 1))}"
    slug="${slug%_}_${hash}"
  fi

  # Truncate to max_len (and ensure no trailing underscore left by truncation)
  slug="${slug:0:$max_len}"
  echo "${slug%_}"
}

verify_socket_path() {
  local len
  # Byte count, not character count
  len=$(printf '%s' "$DOCKER_SOCKET" | wc -c | tr -d ' ')
  if [[ "$len" -gt $MAX_SOCKET_PATH_LEN ]]; then
    error "Docker socket path is $len bytes, the macOS limit is $MAX_SOCKET_PATH_LEN:"
    die "  $DOCKER_SOCKET"
  fi
}

verify_project_path() {
  # limactl start splits --param values on commas
  case "$CURRENT_DIR" in
  *,*) die "Project path must not contain ',': $CURRENT_DIR" ;;
  esac
}

ensure_socket_link() {
  # Create the short real socket directory, then point the in-project
  # $WORKDIR/.nono/d at it. The symlink must exist before nono starts, so the
  # profile's unix_socket_dir grant canonicalizes through it to the real dir.
  #
  # Guard the real dir against a /tmp hijack, mirroring nono's own
  # create_socket_link: reject a pre-existing symlink or one owned by another
  # user before writing the socket into it.
  if [[ -L "$REAL_SOCKET_DIR" ]]; then
    die "Refusing to use socket dir (it is a symlink): $REAL_SOCKET_DIR"
  fi
  if [[ -e "$REAL_SOCKET_DIR" ]]; then
    local owner
    owner=$(stat -f '%u' "$REAL_SOCKET_DIR" 2>/dev/null || echo)
    [[ "$owner" == "$(id -u)" ]] ||
      die "Refusing to use socket dir (not owned by current user): $REAL_SOCKET_DIR"
  fi
  mkdir -p "$REAL_SOCKET_DIR"

  mkdir -p "$CURRENT_DIR/.nono"
  if [[ -L "$SOCKET_LINK_DIR" ]]; then
    local target
    target=$(readlink "$SOCKET_LINK_DIR")
    if [[ "$target" != "$REAL_SOCKET_DIR" ]]; then
      rm -f "$SOCKET_LINK_DIR"
      ln -s "$REAL_SOCKET_DIR" "$SOCKET_LINK_DIR"
    fi
  elif [[ -e "$SOCKET_LINK_DIR" ]]; then
    die "Expected $SOCKET_LINK_DIR to be a symlink or empty; remove it and retry"
  else
    ln -s "$REAL_SOCKET_DIR" "$SOCKET_LINK_DIR"
  fi
}

ensure_project_dirs() {
  mkdir -p "$DOCKER_CONFIG_DIR"
  ensure_socket_link
}

verify_mount_location() {
  local vm_name="$1"
  info "Validating mount configuration for Lima VM '$vm_name'"

  local mount_paths=() line
  while IFS= read -r line; do
    mount_paths+=("$line")
  done < <(
    limactl list --all-fields --format json "$vm_name" 2>/dev/null |
      jq -r '.config.mounts[]?.location'
  )

  local mount_count="${#mount_paths[@]}"
  if [[ "$mount_count" -ne 1 ]]; then
    error "Expected exactly 1 mount point, but found $mount_count."
    if [[ "$mount_count" -gt 0 ]]; then
      error "Configured mounts:"
      for path in "${mount_paths[@]}"; do
        error "  $path"
      done
    fi
    die
  fi

  local single_mount="${mount_paths[0]}"
  if [[ "$single_mount" != "$CURRENT_DIR" ]]; then
    error "Mount point path mismatch!"
    error "  Expected: $CURRENT_DIR"
    error "  But was:  $single_mount"
    die
  fi

    info "Mount point path is corect."
    info "  mount-path:  $single_mount"
}

verify_socket_location() {
  local vm_name="$1"
  local configured
  configured=$(
    limactl list --all-fields --format json "$vm_name" 2>/dev/null |
      jq -r '.config.param.DockerSocket // ""'
  )
  if [[ "$configured" != "$DOCKER_SOCKET" ]]; then
    error "Docker socket forward mismatch for VM '$vm_name'!"
    error "  Expected: $DOCKER_SOCKET"
    error "  But was:  ${configured:-<not set, VM was created by an older version of this script>}"
    die "Delete the VM (limactl delete $vm_name) and run '$0 start' to recreate it"
  fi
}

start_existing() {
  local vm_name="$1" status="$2"
  verify_mount_location "$vm_name"
  verify_socket_location "$vm_name"
  ensure_project_dirs
  if [[ "$status" == "Running" ]]; then
    info "VM '$vm_name' is already running. Nothing to do."
  else
    info "VM '$vm_name' is in state '$status'. Starting..."
    limactl start --tty=false "$vm_name"
  fi
  print_host_docker_hint
}

# Runs as root in the guest. Supports the package managers of the
# distributions that Docker's get.docker.com installer supports.
GUEST_UPGRADE_SCRIPT='
set -eu
if command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get upgrade -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold
elif command -v dnf >/dev/null 2>&1; then
  dnf upgrade -y --refresh
elif command -v zypper >/dev/null 2>&1; then
  zypper --non-interactive refresh
  zypper --non-interactive update
else
  echo "No supported package manager (apt-get, dnf, zypper) found in the VM" >&2
  exit 1
fi
'

upgrade_existing() {
  # Upgrades the guest OS and Docker packages in place, then restarts the VM
  # to load a new kernel and the upgraded rootless dockerd. Images and
  # volumes are kept. A new OS release needs a recreated VM instead.
  local vm_name="$1" status="$2"
  verify_mount_location "$vm_name"
  verify_socket_location "$vm_name"
  if [[ "$status" != "Running" ]]; then
    info "VM '$vm_name' is in state '$status'. Starting..."
    limactl start --tty=false "$vm_name"
  fi
  info "Upgrading packages in VM '$vm_name'..."
  limactl shell --workdir / "$vm_name" sudo sh -c "$GUEST_UPGRADE_SCRIPT"
  info "Restarting VM '$vm_name'..."
  limactl stop "$vm_name"
  limactl start --tty=false "$vm_name"
  info "VM '$vm_name' upgraded and running."
}

create_and_start() {
  # Creates a fresh VM from the template and starts it. Assumes the VM does
  # not already exist.
  local vm_name="$1"
  verify_project_path
  verify_socket_path
  ensure_project_dirs
  info "VM '$vm_name' does not exist. Creating and starting from '$TEMPLATE'..."
  limactl start \
    --name="$vm_name" \
    --tty=false \
    --mount-only "$CURRENT_DIR:w" \
    --param "DockerSocket=$DOCKER_SOCKET" \
    --param "ProjectPath=$CURRENT_DIR" \
    "$TEMPLATE"
  verify_mount_location "$vm_name"
  print_host_docker_hint
}

confirm_destructive() {
  # Prompts before a destructive action unless --yes was given.
  [[ "$ASSUME_YES" == true ]] && return 0
  warn "$1"
  warn "Continue? [y/N] "
  local reply
  read -r reply
  case "$reply" in
  y | Y | yes | YES) return 0 ;;
  *) die "Aborted." ;;
  esac
}

delete_existing() {
  # Deletes the VM. Destructive: images, volumes and build cache are lost.
  # The project's .nono/d and .nono/docker-config directories are left in
  # place; they are reused if the VM is recreated.
  local vm_name="$1"
  confirm_destructive "This deletes VM '$vm_name'. Images, volumes and build cache are lost."
  info "Deleting VM '$vm_name'..."
  limactl delete --force "$vm_name"
}

recreate_existing() {
  # Deletes the VM and creates a fresh one. Clears any persistence an agent
  # left in the VM (D32) and is the way to pick up a new OS image or template
  # changes.
  local vm_name="$1"
  delete_existing "$vm_name"
  create_and_start "$vm_name"
}

list_orphans() {
  local name path found=false
  while IFS=$'\t' read -r name path; do
    if [[ ! -d "$path" ]]; then
      found=true
      echo -e "$name\t$path"
    fi
  done < <(
    limactl list --all-fields --format json 2>/dev/null |
      jq -r 'select((.config.param.ProjectPath // "") != "") | [.name, .config.param.ProjectPath] | @tsv'
  )
  [[ "$found" == true ]] || info "No orphaned sandboxed VMs."
}

print_host_docker_hint() {
  # Inside the sandbox the before-hook sets DOCKER_HOST automatically.
  # This hint is for driving docker from the host shell against this VM.
  info "To use this engine from a host shell, run:"
  echo "export DOCKER_HOST=unix://$DOCKER_SOCKET"
}
print_env() {
  # KEY=VALUE lines for the nono before-hook's NONO_ENV_FILE.
  # Lima creates the guest user with the host user's UID, so the rootless
  # socket inside the VM is /run/user/<host uid>/docker.sock.
  echo "DOCKER_HOST=unix://$DOCKER_SOCKET"
  echo "DOCKER_CONFIG=$DOCKER_CONFIG_DIR"
  echo "DOCKER_CERT_PATH=$DOCKER_CONFIG_DIR"
  echo "TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/run/user/$(id -u)/docker.sock"
}

main() {
  prereq
  parse_args "$@"

  # Action is not on a specific VM.
  if [[ "$ACTION" == "list-orphans" ]]; then
    list_orphans
    return
  fi

  local vm_name
  vm_name=$(get_path_slug)
  [[ -n "$vm_name" ]] || die "Cannot derive a VM name from $CURRENT_DIR"

  # Real socket dir, keyed by uid (for the shared /tmp fallback) and the slug.
  REAL_SOCKET_DIR="$SOCKET_BASE/nono-docker-$(id -u)-$vm_name"
  DOCKER_SOCKET="$REAL_SOCKET_DIR/s"

  local status
  status=$(get_vm_status "$vm_name")

  case "$ACTION" in
  start)
    if [[ -z "$status" ]]; then
      create_and_start "$vm_name"
    else
      start_existing "$vm_name" "$status"
    fi
    ;;
  recreate)
    if [[ -z "$status" ]]; then
      info "VM '$vm_name' does not exist. Creating..."
      create_and_start "$vm_name"
    else
      recreate_existing "$vm_name"
    fi
    ;;
  start-if-exists)
    if [[ -z "$status" ]]; then
      info "No sandboxed VM for $CURRENT_DIR. Skipping."
    else
      start_existing "$vm_name" "$status"
    fi
    ;;
  upgrade)
    if [[ -z "$status" ]]; then
      info "VM '$vm_name' does not exist."
    else
      upgrade_existing "$vm_name" "$status"
    fi
    ;;
  stop)
    if [[ -z "$status" ]]; then
      info "VM '$vm_name' does not exist."
    else
      info "Stopping VM '$vm_name'..."
      limactl stop "$vm_name" || true
    fi
    ;;
  delete)
    if [[ -z "$status" ]]; then
      info "VM '$vm_name' does not exist."
    else
      delete_existing "$vm_name"
    fi
    ;;
  status)
    if [[ -z "$status" ]]; then
      info "VM '$vm_name' does not exist."
    else
      info "VM '$vm_name' status: $status"
      verify_mount_location "$vm_name"
      verify_socket_location "$vm_name"
    fi
    ;;
  print-env)
    # Only for a running VM, so a sandbox never gets variables for an
    # engine that isn't there
    if [[ "$status" == "Running" ]]; then
      print_env
    fi
    ;;
  *)
    die "Unexpected command $ACTION"
    ;;
  esac
}

main "$@"
