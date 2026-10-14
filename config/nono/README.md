# nono configuration

Personal [nono](https://github.com/nolabs-ai/nono) sandbox configuration: the
profiles each agent harness runs under, plus the scripts and Lima templates for
per-project sandboxed Docker.

Install location: `~/.config/nono/` (kept in dotfiles at `~/.dotfiles/config/nono/`).

## Directory layout

| Folder | What's in it |
|---|---|
| `profiles/` | Active profiles nono loads. Hand-edited `.jsonc` (and promoted `.json`). Selected with `--profile` or `NONO_PROFILE`. |
| `profile-drafts/` | Staging area. Draft `.json` files are edited here, then `nono profile promote <name>` copies them into `profiles/`. Sandboxed agents may write here but never directly to `profiles/`. |
| `scripts/` | Hook and management scripts. `sandboxed-docker.sh` (run by hand to manage VMs) and `start-sandboxed-docker.sh` (the nono before-hook). |
| `lima/` | Lima VM templates. `sandboxed-docker.yaml` (rootless Docker, one VM per project). |
| `docs/` | Design docs. `sandboxed-docker.md` covers the Docker setup end to end. |

In `profile-drafts/` you'll also see:
- `*.base` - a sha256 checksum of the last-promoted version, used to detect drift between a draft and the profile it was promoted to.
- `.nono-*-pack-marker` - marker files that ensure the directory exists and record the drafts-vs-profiles rule.

## Profiles

| Profile | Purpose | Extends |
|---|---|---|
| `default-local` | Shared base every harness profile builds on. Workdir read-write and the common filesystem grants. Not run directly. | `default`, `java-tools`, `sandboxed-docker` |
| `claude-local` | Claude Code harness. | `nolabs-ai/claude`, `default-local` |
| `omp-local` | omp harness. | `nolabs-ai/omp`, `default-local` |
| `opencode-local` | opencode harness. | `nolabs-ai/opencode`, `default-local` |
| `pi-local` | pi-code harness. | `nolabs-ai/pi`, `default-local` |
| `claude-scratch` | Ad-hoc scratch profile layered on `claude-local`. Tweaked per task to loosen or tighten permissions. | `claude-local` |
| `java-tools` | Mixin: Java build tools (`~/.m2/repository`, `~/.gradle`). No `extends` of its own. | - |
| `sandboxed-docker` | Mixin: grants the project's forwarded Docker socket (`$WORKDIR/.nono/d`) and starts its VM via a before-hook. See `docs/sandboxed-docker.md`. | - |

`nolabs-ai/<name>` entries are registry packs; `default` is nono's built-in base.

## Who extends who

```
claude-scratch
└─ claude-local
   ├─ nolabs-ai/claude          · registry pack
   └─ default-local
      ├─ default                · built-in base
      ├─ java-tools             · mixin
      └─ sandboxed-docker       · mixin

omp-local       ─┐
opencode-local  ─┼─ each: nolabs-ai/<harness> (pack) + default-local (as above)
pi-local        ─┘
```

`default-local` is the shared base that every harness profile extends, and
through it they pull in `java-tools` and `sandboxed-docker`.

## Selecting a profile

A profile is chosen with `--profile <name>` or the `NONO_PROFILE` environment
variable; nono has no per-directory discovery. Exporting
`NONO_PROFILE=claude-local` in the shell profile makes `nono run -- claude`
work with no arguments.

### Aliases

Shell aliases launch each agent harness under its matching `*-local` profile.
Every `nn<x>` runs `nono run --allow-cwd $(__git_dir_arg) --profile <profile> -- <harness>`,
where `--allow-cwd` grants the working directory and `$(__git_dir_arg)` grants
the repo's shared git directory (see below).

| Alias | Harness | Profile |
|---|---|---|
| `nn` | - | bare `nono` (no profile or harness) |
| `nnc` | `claude` | `claude-local` |
| `nno` | `opencode` | `opencode-local` |
| `nnp` | `pi` | `pi-local` |
| `nnm` | `omp` | `omp-local` |

### `__git_dir_arg`

```sh
__git_dir_arg() {
    local git_dir
    if git_dir=$(git rev-parse --git-common-dir 2>/dev/null); then
        echo --allow "$git_dir"
    fi
}
```

Emits `--allow <git-common-dir>` so nono grants the repo's real git directory,
or nothing when run outside a repo (leaving the alias unchanged). It matters in
a git worktree: the worktree's own `.git` is just a pointer, while the object
store and refs live in the main repo's `.git` (the common dir), outside the
worktree directory that `--allow-cwd` covers. Without this grant, git commands
inside a sandboxed worktree would be denied access to that shared directory.

## Editing profiles

Two ways in, depending on who's editing:

- **By hand (the usual case).** The `.jsonc` profiles (`default-local`, the
  `*-local` harness profiles and `claude-scratch`) are edited directly in
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

When a session needs grants the base profiles don't have, use `claude-scratch`
as a capture surface instead of editing a real profile directly:

1. Run the harness under `claude-scratch`, which extends the profile you'd
   normally use (`claude-scratch` -> `claude-local`).
2. Grant what you need during the session (capability elevation). On exit, nono
   prompts to update the active profile with the rules it suggests from that
   session. The active profile is `claude-scratch`, so the grants collect there
   and the base profiles stay untouched.
3. Review what landed in `claude-scratch`, then move each grant to where it
   belongs: a tool-specific one to `java-tools`, a shared one to
   `default-local`, and so on. Clear `claude-scratch` afterward.

Experimental grants stay out of the shared profiles until you've decided where
they belong.

Capability elevation has two parts. Granting live during a session is Linux
only and disabled on WSL2. The exit-time prompt that saves suggested rules to
the active profile works on all platforms. On macOS the grants come from that
exit prompt.

## Sandboxed Docker

The `sandboxed-docker` profile, the `scripts/` and the `lima/` template give a
project its own rootless Docker engine in a dedicated Lima VM, so an agent can
build and test with containers without touching the host's Docker.

How it works:

- **Opt in once, outside the sandbox.** Run `sandboxed-docker.sh start` in the
  project. It creates one VM per project directory and mounts only that
  directory.
- **Socket wiring.** The VM's Docker socket is forwarded to a short path under
  `$XDG_RUNTIME_DIR` (or `/tmp`), and the project's `.nono/d` is a symlink to
  it. The `sandboxed-docker` profile grants `unix_socket_dir` on
  `$WORKDIR/.nono/d`. The short path keeps the socket within the macOS
  `sun_path` limit no matter how deep the project path is.
- **In a session**, the before-hook starts the project's VM if it exists and
  injects `DOCKER_HOST` and related variables. No VM means no Docker and no
  variables. The hook never creates a VM, and the agent can't opt itself in
  (it has no `limactl` or `~/.lima` access).

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
- Opt-in per project: a project with no VM has no socket and no grant.
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

# stop all running VMs except default and docker
limactl list -q --filter '.status == "Running"' \
  --filter '.name != "default"' --filter '.name != "docker"' \
  | xargs -I {} limactl stop {}

# delete all stopped VMs
limactl list -q --filter '.status == "Stopped"' | xargs -I {} limactl delete --force {}

# delete all VMs except default and docker
# (no status filter, and --force also deletes running ones)
limactl list -q --filter '.name != "default"' --filter '.name != "docker"' \
  | xargs -I {} limactl delete --force {}
```
