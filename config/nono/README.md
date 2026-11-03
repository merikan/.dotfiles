# nono configuration

Personal [nono](https://github.com/nolabs-ai/nono) sandbox configuration: the
profiles each agent harness runs under, plus the scripts and Lima templates for
per-project sandboxed Docker.

Install location: `~/.config/nono/` (kept in dotfiles at `~/.dotfiles/config/nono/`).

## Directory layout

| Folder | What's in it |
|---|---|
| `profiles/` | Active profiles nono loads. Hand-edited `.jsonc` (and promoted `.json`). Selected with `--profile` or `NONO_PROFILE`. |
| `profile-drafts/` | Staging area. Lives only in `~/.config/nono/profile-drafts/`, not in dotfiles. Draft `.json` files are edited here, then `nono profile promote <name>` copies them into `profiles/`. Sandboxed agents may write here but never directly to `profiles/`. |
| `scripts/` | Hook and management scripts. `sandboxed-docker.sh` (run by hand to manage VMs) and `start-sandboxed-docker.sh` (the nono before-hook), plus `ping-docker-socks.sh` (debug helper that pings `/_ping` on each `docker.sock` under `~/.lima`). |
| `lima/` | Lima VM templates. `sandboxed-docker.yaml` (rootless Docker, one VM per project). |

In `profile-drafts/` you'll also see:
- `*.base` - a sha256 checksum of the last-promoted version, used to detect drift between a draft and the profile it was promoted to.
- `.nono-*-pack-marker` - marker files that ensure the directory exists and record the drafts-vs-profiles rule.

## Profiles

| Profile | Purpose | Extends |
|---|---|---|
| `default-local` | Shared base every harness profile builds on. Common filesystem grants, including the worktree's shared git directory (`@git:common-dir`). Not run directly. | `default`, `java-tools`, `docker` |
| `claude-local` | Claude Code harness. | `nolabs-ai/claude`, `default-local` |
| `omp-local` | omp harness. | `nolabs-ai/omp`, `default-local` |
| `opencode-local` | opencode harness. | `nolabs-ai/opencode`, `default-local` |
| `pi-local` | pi-code harness. | `nolabs-ai/pi`, `default-local` |
| `scratch` | Ad-hoc scratch profile layered on `claude-local`. Tweaked per task to loosen or tighten permissions. | `claude-local` |
| `java-tools` | Mixin: Java build tools (`~/.m2/repository`, `~/.gradle`). No `extends` of its own. | - |
| `docker` | Mixin: Docker access for agents. By default it points `DOCKER_HOST` at the shared `docker-nomount` Lima VM (`~/.lima/docker-nomount/sock/docker.sock`). If the project has its own sandboxed Docker VM, the before-hook starts it and injects `DOCKER_HOST` for the project's forwarded socket (`$WORKDIR/.nono/d`). Also grants read-write access to `~/.docker/config.json`. See [Sandboxed Docker](#sandboxed-docker). | - |

`nolabs-ai/<name>` entries are registry packs; `default` is nono's built-in base.

## Who extends who

```
scratch
└─ claude-local
   ├─ nolabs-ai/claude          · registry pack
   └─ default-local
      ├─ default                · built-in base
      ├─ java-tools             · mixin
      └─ docker                 · mixin

omp-local       ─┐
opencode-local  ─┼─ each: nolabs-ai/<harness> (pack) + default-local (as above)
pi-local        ─┘
```

`default-local` is the shared base that every harness profile extends, and
through it they pull in `java-tools` and `docker`.

## Selecting a profile

A profile is chosen with `--profile <name>` or the `NONO_PROFILE` environment
variable; nono has no per-directory discovery. Exporting
`NONO_PROFILE=claude-local` in the shell profile makes `nono run -- claude`
work with no arguments.

### Aliases

Shell aliases launch each agent harness under its matching `*-local` profile.
Every `nn<x>` runs `nono run --allow-cwd --profile <profile> -- <harness>`,
where `--allow-cwd` grants the working directory. In a git worktree, the
object store and refs live in the main repo's `.git`, outside the working
directory. `default-local` grants that shared directory with `@git:common-dir`.

| Alias | Harness | Profile |
|---|---|---|
| `nn` | - | bare `nono` (no profile or harness) |
| `nnc` | `claude` | `claude-local` |
| `nno` | `opencode` | `opencode-local` |
| `nnp` | `pi` | `pi-local` |
| `nnm` | `omp` | `omp-local` |

## Editing profiles

Two ways in, depending on who's editing:

- **By hand (the usual case).** The `.jsonc` profiles (`default-local`, the
  `*-local` harness profiles and `scratch`) are edited directly in
  `profiles/`. Rather than editing the shared profiles blind, I collect changes
  through the scratch-profile workflow below, then move each grant into the
  right `.jsonc`.
- **Via an AI agent.** A sandboxed agent can't write to `profiles/`; it's only
  allowed to write drafts to `profile-drafts/`. So the agent writes a draft
  `.json` there, and you publish it with `nono profile promote <name>`.
  Validate with `nono profile validate <name>` (or `--draft <name>`, or a file
  path).

**JSON vs JSONC gotcha.** `nono profile promote` always writes `<name>.json`,
but nono loads `<name>.jsonc` first when both exist. Promoting a draft over a
profile you maintain as `.jsonc` therefore has no effect: the `.json` is
ignored. Either keep that profile as plain `.json` so promote takes effect, or
hand-merge the draft's changes into the `.jsonc`.

### Scratch-profile workflow

When a session needs grants the base profiles don't have, use `scratch`
as a capture surface instead of editing a real profile directly:

1. Run the harness under `scratch`, which extends the profile you'd
   normally use (`scratch` -> `claude-local`).
2. Grant what you need during the session (capability elevation). On exit, nono
   prompts to update the active profile with the rules it suggests from that
   session. The active profile is `scratch`, so the grants collect there
   and the base profiles stay untouched.
3. Review what landed in `scratch`, then move each grant to where it
   belongs: a tool-specific one to `java-tools`, a shared one to
   `default-local`, and so on. Clear `scratch` afterward.

Experimental grants stay out of the shared profiles until you've decided where
they belong.

Capability elevation has two parts. Granting live during a session is Linux
only and disabled on WSL2. The exit-time prompt that saves suggested rules to
the active profile works on all platforms. On macOS the grants come from that
exit prompt.

## Sandboxed Docker

The `docker` profile, the `scripts/` and the `lima/` template give a
project its own rootless Docker engine in a dedicated Lima VM, so an agent can
build and test with containers without touching the host's Docker.

| File | Purpose |
|---|---|
| `scripts/sandboxed-docker.sh` | Command you run on the host, outside the sandbox. It manages one rootless Docker Lima VM per project: `start`, `stop`, `upgrade`, `recreate`, `delete`, `status`, `list-orphans` and `print-env`. It puts the real socket under a short path in `$XDG_RUNTIME_DIR` or `/tmp`, symlinks `.nono/d` to it, and checks that the VM mounts only the project directory. |
| `scripts/start-sandboxed-docker.sh` | nono before-hook. If the project's VM exists, it starts it (it never creates one) and writes `DOCKER_HOST`, `DOCKER_CONFIG`, `DOCKER_CERT_PATH` and `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE` to `NONO_ENV_FILE`. |
| `profiles/docker.jsonc` | nono profile mixin. It grants `unix_socket_dir` on `$WORKDIR/.nono/d` (connect only), the shared `docker-nomount` socket with `DOCKER_HOST` pointing at it, and read-write `~/.docker/config.json`, and registers the before-hook with a 30 s timeout. |
| `lima/sandboxed-docker.yaml` | Lima template that extends `template:docker`. It sets a fixed size of 2 CPU, 4 GiB RAM and 50 GiB disk, forwards the rootless socket to `param.DockerSocket`, and records `ProjectPath` so `list-orphans` can find VMs whose project is gone. |

How it works:

- **Opt in once, outside the sandbox.** Run `sandboxed-docker.sh start` in the
  project. It creates one VM per project directory and mounts only that
  directory.
- **Socket wiring.** The VM's Docker socket is forwarded to a short path under
  `$XDG_RUNTIME_DIR` (or `/tmp`), and the project's `.nono/d` is a symlink to
  it. The `docker` profile grants `unix_socket_dir` on
  `$WORKDIR/.nono/d`. The short path keeps the socket within the macOS
  `sun_path` limit no matter how deep the project path is.
- **In a session**, the before-hook starts the project's VM if it exists and
  injects `DOCKER_HOST` and related variables. With no project VM, the
  profile's default `DOCKER_HOST` (the shared `docker-nomount` VM) applies
  instead. The hook never creates a VM, and the agent can't opt itself in
  (it has no `limactl`, and its only `~/.lima` access is the `docker-nomount`
  socket).

Commands (`sandboxed-docker.sh <cmd>`, run outside the sandbox): `start`,
`stop`, `status`, `upgrade` (guest OS + Docker packages), `recreate` (fresh
VM), `delete`, `list-orphans`, `print-env`.

Security: a Docker socket is a control plane, so granting it is close to giving
the agent control of the VM - nono can't mediate what the daemon does on the
other side. What contains it:

- The Lima VM is the real boundary; reaching the host means escaping the
  hypervisor, a much higher bar than defeating the sandbox.
- The VM mounts only the project directory (enforced by the script), so a
  container's blast radius is that directory. Never broaden the mount.
- Opt-in per project: a project with no VM has no project socket. It falls
  back to the shared `docker-nomount` VM, which is shared across projects and
  so isn't isolated per project.
- Rootless Docker keeps the agent off guest root.

Keep VMs patched (`upgrade`) and recreate them periodically; if a project
doesn't need Docker, don't start a VM for it.

### Bulk Lima VM cleanup

`sandboxed-docker.sh` acts on the current project's VM, and its `list-orphans`
finds VMs whose project directory is gone. To act across all Lima VMs at once,
including the sandboxed ones, use `limactl` directly. `-q` prints names only,
and `--filter` takes yq expressions (repeatable, combined with AND):

```sh
# list all Lima VMs
limactl ls

# stop all running VMs
limactl list -q --filter '.status == "Running"' | xargs -I {} limactl stop {}

# stop all running VMs except default and docker*
limactl list -q --filter '.status == "Running"' \
  --filter '.name != "default"' --filter '.name != "docker*"' \
  | xargs -I {} limactl stop {}

# delete all stopped VMs
limactl list -q --filter '.status == "Stopped"' | xargs -I {} limactl delete --force {}

# delete all VMs except default and docker*
# (no status filter, and --force also deletes running ones)
limactl list -q --filter '.name != "default"' --filter '.name != "docker*"' \
  | xargs -I {} limactl delete --force {}
```
