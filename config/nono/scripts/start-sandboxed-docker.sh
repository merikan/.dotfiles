#!/usr/bin/env bash
#
#  Starts sandboxed docker engine using Lima
#
#  Only for use as a nono sandbox hook (sandboxed-docker profile). Starts the
#  sandboxed docker engine for the current directory if its VM exists, and
#  injects DOCKER_HOST and related variables into the sandbox.
#  Never creates a VM: run `sandboxed-docker.sh start` outside the sandbox
#  to opt a project in.
#  Expects NONO_ENV_FILE to be set by nono.

set -euo pipefail

hook_msg() { printf '[nono hook] %s\n' "$*" 2>/dev/null >/dev/tty || true; }

script_name=$(basename "$0")
hook_msg "Running hook: $script_name"

if [[ -z "${NONO_ENV_FILE:-}" ]]; then
  hook_msg "NONO_ENV_FILE is not set, not running as a nono hook"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# nono discards hook stdout and stderr, so forward the output to the terminal
if ! output="$("$script_dir/sandboxed-docker.sh" start-if-exists 2>&1)"; then
  hook_msg "Failed to start sandboxed docker:"
  printf '%s\n' "$output" 2>/dev/null >/dev/tty || true
  exit 1
fi
printf '%s\n' "$output" 2>/dev/null >/dev/tty || true

# Empty unless the VM exists and is running
env_lines="$("$script_dir/sandboxed-docker.sh" print-env)"
if [[ -n "$env_lines" ]]; then
  # inject DOCKER variables to the sandbox
  printf '%s\n' "$env_lines" >>"$NONO_ENV_FILE"
fi
