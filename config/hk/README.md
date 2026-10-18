# hk: global git hooks

This directory holds the machine-wide configuration for
[hk](https://hk.jdx.dev/), a git hook manager. The same checks run in every
repo on the machine, including repos that have no hk setup of their own.

Two pieces make that work:

- **Git calls hk in every repo.** The global git config defines hooks that
  run `hk run <event>`. Defining hooks in git config is new in Git 2.54; see
  [Git wiring](#git-wiring).
- **hk reads this config in every repo.** `~/.config/hk/config.pkl` is hk's
  user config location and a symlink to `config.pkl` here.

## Table of Content
- [My setup](#my-setup)
- [How hk works](#how-hk-works)
- [Hooks vs CI](#hooks-vs-ci)
- [Configuring hk](#configuring-hk)
- [Project hooks](#project-hooks)
- [Day-to-day commands](#day-to-day-commands)
- [Troubleshooting](#troubleshooting)

Detailed write-ups of the two custom checks:

- [`signoff-hook.md`](signoff-hook.md): the `commit-msg` sign-off (DCO) check
- [`wip-hook.md`](wip-hook.md): the `pre-push` WIP check

## My setup

### Files

| Path | What it is |
| --- | --- |
| `~/.dotfiles/config/hk/config.pkl` | The global hk config (symlinked to `~/.config/hk/config.pkl`) |
| `~/.dotfiles/config/git/config` | Global git config that wires git events to hk (symlinked to `~/.config/git/config`) |
| `/opt/homebrew/bin/hk` | The hk binary, installed with Homebrew (2.5.0) |

### Git wiring

Since Git 2.54, a hook can be defined in git config instead of as a script in
`.git/hooks`: `hook.<name>.command` is what to run and `hook.<name>.event` is
when. A hook defined in the global git config runs in every repo, with no
per-repo `hk install`. Before 2.54 the usual global option was
`core.hooksPath`, which replaces every repo's own hooks directory.

The global git config has one entry per event:

```ini
hook.hk-commit-msg.command = test "${HK:-1}" = "0" || hk run commit-msg "$@"
hook.hk-commit-msg.event   = commit-msg
hook.hk-pre-commit.command = test "${HK:-1}" = "0" || hk run pre-commit "$@"
hook.hk-pre-commit.event   = pre-commit
hook.hk-pre-push.command   = test "${HK:-1}" = "0" || hk run pre-push "$@"
hook.hk-pre-push.event     = pre-push
```

- `hk-<event>` is the hook's name. Git rejects a hook named after an event,
  such as `hook.pre-commit.command`.
- `test "${HK:-1}" = "0" ||` lets `HK=0 git commit ...` skip hk entirely.
- These commands deliberately leave out `--from-hook`, which
  `hk install --global` adds by default. With that flag, hk does nothing in a
  repo without a project `hk.pkl`, so none of the global checks would run.
  [`signoff-hook.md`](signoff-hook.md#why-the-hook-command-must-not-use---from-hook)
  explains this in detail.

These hooks add to a repo's own hooks rather than replacing them. Git runs
the hooks from config first, then the repo's hook script (`.git/hooks/<event>`,
or the directory in `core.hooksPath`). A repo that uses Husky, lefthook or
pre-commit keeps its hooks and gets these checks as well.

To see which hooks run for an event in the current repo, and where each is
defined:

```sh
git hook list pre-commit --show-scope
```

### Step groups

`config.pkl` defines its steps as reusable `local` mappings, then assigns them
to hooks.

| Group | Steps | Purpose |
| --- | --- | --- |
| `check_leaks` | `betterleaks`, `detect_private_key` | Stop secrets and private keys from being committed or pushed |
| `linters` | `bom`, `check_add_large_files`, `check_case_conflict`, `check_executables_have_shebangs`, `check_symlinks`, `editorconfig_checker`, `shellcheck`, `shfmt` | General file hygiene and shell script linting |
| `check_signoff` | `signoff` | Require a `Signed-off-by` trailer in repos that opt in |
| `check_wip` | `no_wip` | Block pushing commits with `WIP` in the subject |

Every step except `signoff` and `no_wip` is an hk builtin
(`Builtins.<name>`; list them with `hk builtins`).

### Hooks

| Hook | Runs | Steps | Fixes files? |
| --- | --- | --- | --- |
| `commit-msg` | On every commit, after the message is written | `check_signoff` | No |
| `pre-commit` | On every commit, before the message | `check_leaks` | No |
| `pre-push` | On every push, before anything is sent | `check_leaks` + `check_wip` | No |
| `check` | Manually: `hk check` | `linters` + `check_leaks` | No |
| `lint` | Manually: `hk run lint` | `linters` | No |
| `fix` | Manually: `hk fix` | `linters` | Yes |
| `leaks` | Manually: `hk run leaks` | `check_leaks` | No |

Only `commit-msg`, `pre-commit` and `pre-push` are tied to git events. The
others run only when you call them.

`check` and `pre-push` combine two groups with Pkl's spread operator, which copies every
entry of a mapping into the enclosing one:

```pkl
["pre-push"] {
  steps {
    ...check_leaks
    ...check_wip
  }
}
```

### Opt-ins and bypasses

| What | How |
| --- | --- |
| Enforce sign-off in a repo | `git config hk.requireSignoff true` (undo with `git config --unset hk.requireSignoff`) |
| Skip all hk hooks for one command | `HK=0 git commit ...` / `HK=0 git push ...` |
| Turn off one hk hook in a repo | `git config hook.hk-pre-push.enabled false` (undo with `git config --unset hook.hk-pre-push.enabled`) |
| Skip all git hooks for one command | `git commit --no-verify` / `git push --no-verify` |

## How hk works

### The pieces

- **Hook**: a named set of steps. Hooks named after a git event
  (`pre-commit`, `commit-msg`, `pre-push`, ...) run when git fires that event.
  Any other name, such as `lint`, is a custom hook you run with
  `hk run <name>`. `hk check` and `hk fix` are shortcuts for the hooks named
  `check` and `fix`.
- **Step**: one tool invocation inside a hook, usually a linter or formatter.
  A step has a `check` command (reports problems, exits non-zero on failure)
  and optionally a `fix` command (rewrites files).
- **Builtin**: a ready-made step definition that ships with hk, such as
  `Builtins.shellcheck`. It's configuration, not the tool itself; see below.

### Builtins are configuration, not tools

A builtin is a step definition: which command to run, which files it applies
to, and how to check and fix. It doesn't include the program it calls.
`Builtins.betterleaks` runs `betterleaks dir --redact ... {{files}}`, and
`betterleaks` has to be installed and on `PATH` for that to work.

Some builtins call `hk util <check>` instead, a check built into the hk
binary, and need nothing beyond hk itself. The steps in this config split
like this:

| Step | Runs | Needs |
| --- | --- | --- |
| `betterleaks` | `betterleaks` | [betterleaks](https://github.com/betterleaks/betterleaks) installed |
| `editorconfig_checker` | `editorconfig-checker` | [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker) installed |
| `shellcheck` | `shellcheck` | [ShellCheck](https://github.com/koalaman/shellcheck) installed |
| `shfmt` | `shfmt` | [shfmt](https://github.com/mvdan/sh) installed |
| `detect_private_key`, `bom`, `check_add_large_files`, `check_case_conflict`, `check_executables_have_shebangs`, `check_symlinks` | `hk util ...` | Only hk |

If a tool is missing, its step fails and the hook blocks the commit or push:

```
betterleaks: command not found; is it installed and on PATH?
```

Before adding a builtin, look up the command it runs at
https://hk.jdx.dev/builtins.html and install that tool on every machine that
uses this config.

### What happens on `git commit`

1. Git fires `pre-commit` and runs the configured hook command, which calls
   `hk run pre-commit`.
2. hk loads its config (see [where config comes from](#where-config-comes-from)).
3. hk selects files. For `pre-commit` that is the staged files; for manual
   hooks it is the modified files, or all files with `--all`.
4. Each step's `glob`/`types` filters narrow the file list for that step.
   Steps with no matching files are skipped.
5. Steps run in parallel, up to `--jobs` at a time, unless `depends` or
   `exclusive` says otherwise. hk substitutes template variables such as
   `{{files}}` into each command.
6. If the hook has `fix = true`, hk runs `fix` commands and can stage the
   changed files. Otherwise it runs `check` commands.
7. Any failing step makes hk exit non-zero, and git aborts the commit.

`commit-msg` and `pre-push` follow the same flow but receive extra input
from git, exposed as template variables:

| Variable | Hook | Contents |
| --- | --- | --- |
| `{{files}}` | all | The files selected for the step |
| `{{commit_msg_file}}` | `commit-msg` | Path to the commit message file |
| `{{hook_stdin}}` | `pre-push` | Git's stdin: one `<local ref> <local sha> <remote ref> <remote sha>` line per pushed ref |

hk pastes template values into the script text before the shell runs it.
Values that can contain shell metacharacters (branch names in
`{{hook_stdin}}`, for example) must be fed through a quoted heredoc rather
than placed in the command directly. `no_wip` shows how; see
[`wip-hook.md`](wip-hook.md#how-the-script-works).

### Where config comes from

hk merges settings from several layers. From lowest to highest precedence:

1. Built-in defaults
2. User config: `~/.config/hk/config.pkl` (this directory)
3. Project config: `hk.pkl` in the repo
4. Git config (`hk.*` keys; local overrides global)
5. `HK_*` environment variables
6. CLI flags

For hooks and steps, the user config and a project `hk.pkl` merge by name.
[Project hooks](#project-hooks) shows what that means in practice.

`hk config sources` prints this order, and `hk config dump` shows the
effective values.

## Hooks vs CI

Git hooks run on every commit and push, on your machine, while you wait. Anyone
can skip them with `HK=0` or `--no-verify`. That decides what belongs in them.

**Hooks catch what is expensive to undo once it leaves the machine.** A
pushed secret is exposed and has to be rotated, even if CI flags it a minute
later. A WIP commit or a missing sign-off on a shared branch means rewriting
published history. These checks earn their place in a hook:

- secrets and private keys (`check_leaks`)
- WIP commits on push (`check_wip`)
- the DCO sign-off in repos that need it (`check_signoff`)

**CI catches everything else.** The full test suite, builds, type checks
across the whole repo, slow linters, dependency audits and history-wide
secret scans all belong in CI. CI runs on a clean machine, can't be skipped,
and doesn't block anyone's next commit while it works.

**A slow hook gets bypassed, and a bypassed hook catches nothing.** If
committing starts to feel sluggish, `HK=0` becomes a habit and the secret
scan goes with it. So a hook step should:

- run only on the files being committed or pushed (`{{files}}`), never the
  whole repo
- work offline
- finish fast enough that you don't notice it

Anything that breaks those rules goes in CI, or in a manual hook such as
`check` that you run when you choose. That's why the linters in this config run
through `hk check` and `hk fix`, and the git hooks only run the leak, WIP and
sign-off checks.

**Keep test suites out of hooks.** Unit tests, integration tests, end-to-end
tests and full builds take minutes, often need a database, containers or the
network, and can fail for reasons that have nothing to do with the commit,
such as a flaky test or a service that isn't running. In a hook they make
every commit wait and teach people to reach for `HK=0`.

**Running tests before pushing is a policy, not a hook.** Developers should
still run the tests and linters before they push. Write that down in the
project's contributing guide (such as `CONTRIBUTING.md`), with the exact
commands to run, for example `hk check --all` and the test command, and let
CI enforce it on every pull request. Hooks stop what can't be taken back;
the policy and CI take care of correctness.

## Configuring hk

### Pkl basics

hk configs are written in [Pkl](https://pkl-lang.org/), a typed configuration
language. hk evaluates Pkl itself, so the Pkl CLI is not required.

```pkl
amends "package://github.com/jdx/hk/releases/download/v2.5.0/hk@2.5.0#/Config.pkl"
import "package://github.com/jdx/hk/releases/download/v2.5.0/hk@2.5.0#/Builtins.pkl"
```

- `amends` makes this file an instance of hk's `Config` schema. Unknown or
  mistyped fields are errors.
- `import` makes `Builtins.<name>` available.

Pkl syntax used in `config.pkl`:

| Syntax | Meaning |
| --- | --- |
| `local name = new Mapping<String, Step> { ... }` | A private value, not part of the output. Used here to define reusable step groups |
| `["key"] = value` | Set a mapping entry to a value |
| `["key"] { ... }` | Create or amend a mapping entry in place |
| `steps = check_leaks` | Use an existing mapping as-is |
| `...check_leaks` | Spread: copy all entries of a mapping into the current one |
| `"""` ... `"""` | Multi-line string. Leading indentation is stripped. In step scripts, write `printf` escapes with one backslash (`\n`); `\\n` prints a literal `\n` |
| `///` | Doc comment; `//` is a regular comment |

### Add a builtin step

Add it to a group, for example `linters`:

```pkl
local linters = new Mapping<String, Step> {
  // ...
  ["prettier"] = Builtins.prettier
}
```

Every hook that uses `linters` (`check`, `lint` and `fix`) picks it up. `hk builtins`
lists what is available, and https://hk.jdx.dev/builtins.html documents each
one.

To change a builtin's settings, amend it instead of assigning it:

```pkl
["shellcheck"] = (Builtins.shellcheck) {
  exclude = List("vendor/**")
}
```

### Add a custom step

```pkl
local my_checks = new Mapping<String, Step> {
  ["no_todo"] {
    glob = List("*.rs", "*.ts")
    check = "! grep -n 'TODO' {{files}}"
  }
}
```

Common `Step` fields:

| Field | Purpose |
| --- | --- |
| `check` | Command that reports problems; non-zero exit fails the step |
| `fix` | Command that rewrites files; used when the hook has `fix = true` |
| `glob`, `types`, `exclude` | Which files the step applies to |
| `batch` | Split files into parallel batches (for slow single-threaded tools) |
| `depends` | Run after the named steps finish |
| `exclusive` | Run with no other steps in parallel |
| `stage` | Which files to `git add` after a fix |
| `env` | Extra environment variables |
| `condition` | Expression that decides whether the step runs at all |

The full schema, with doc comments, is `Config.pkl` in the hk release that
the `amends` line points to.

### Add or change a hook

```pkl
hooks {
  ["pre-commit"] {
    fix = false      // run check commands, not fix commands
    stash = "git"    // stash unstaged changes while steps run
    steps {
      ...check_leaks
      ...my_checks
    }
  }
}
```

Common `Hook` fields:

| Field | Default | Purpose |
| --- | --- | --- |
| `steps` | empty | The steps to run |
| `fix` | `false` (`true` for `fix`) | Run `fix` commands instead of `check` |
| `stage` | `true` for `pre-commit`, else `false` | Stage files changed by fixes |
| `stash` | `"none"` | `"git"` stashes unstaged changes so steps only see what is staged |
| `fail_on_fix` | `false` | Fail the hook if a fix changed files, so you can review before staging |
| `env` | empty | Environment variables for every step in the hook |
| `enabled` | `true` | Set `false` to turn a hook off |

A new git event (for example `post-checkout`) also needs a matching
`hook.hk-<event>.command` / `.event` pair in the global git config, without
`--from-hook`.

### Validate a change

```sh
hk check --plan           # show which steps would run, without running them
hk run pre-commit --plan
hk check -v               # run with debug output
```

`--plan` evaluates the whole config, so it also catches Pkl errors.

## Project hooks

A repo can have its own hk config: `hk.pkl` at the repo root, committed so
everyone who works on the repo runs the same checks.

### Setting one up

```sh
hk init          # creates hk.pkl, with steps for any linters it detects
hk check --all   # try it on the whole repo
git add hk.pkl
```

On this machine, skip `hk install`. The global git hooks already call hk in
every repo, and `hk install` sees them and does nothing:

```
hk hooks already configured globally (~/.gitconfig); skipping local install.
```

`hk install --force-local` would add per-repo hooks anyway, and hk would then
run twice per event.

Other people who clone the repo run `hk install` once. On Git 2.54+ that adds
`hook.hk-*` entries to the repo's `.git/config`; on older Git it writes
scripts to `.git/hooks`. They get only the checks in `hk.pkl`. This global
config is personal and applies only on this machine.

### How it combines with the global config

In a repo with an `hk.pkl`, hk loads both configs and merges hooks and steps
by name. Tested with hk 2.5.0:

| The project's `hk.pkl` | Result |
| --- | --- |
| Defines a hook the global config doesn't have | The hook is added |
| Defines a hook the global config also has, such as `pre-commit` | Steps from both run |
| Defines a step with the same name as a global step in the same hook | The project's step replaces the global one |
| Has a top-level `steps` block | Those steps are added to `check`, `fix` and `pre-commit`, next to the global steps |

For example, a project `hk.pkl` with this hook:

```pkl
hooks {
  ["pre-commit"] {
    steps {
      ["proj_step"] { check = "echo proj" }
    }
  }
}
```

runs three steps on commit:

```
$ hk run pre-commit --plan
Plan: pre-commit
    ✓ proj_step
    ✓ betterleaks
    ✓ detect_private_key
```

Name collisions replace steps without any warning. A project step called
`betterleaks` takes the place of the global secret scan in that repo. After
adding or changing a project `hk.pkl`, run `hk run <hook> --plan` and check
the global steps are still listed.

### Overriding a project locally

| What | How |
| --- | --- |
| Change the project config just for you | Create `hk.local.pkl` next to `hk.pkl`, starting with `amends "hk.pkl"`, and keep it uncommitted. The global config still merges in |
| Skip a step in one repo | `git config --local hk.skipSteps detect_private_key` (comma-separated for several) |
| Skip an hk hook in one repo | `git config --local hk.skipHook pre-push` |
| Turn off the git hook itself in one repo | `git config hook.hk-pre-push.enabled false` |

The skip settings apply to project and global steps alike.

## Day-to-day commands

| Command | What it does |
| --- | --- |
| `hk check` | Lint modified files and scan them for secrets |
| `hk check --all` | Same, for every file in the repo |
| `hk run lint` | Lint modified files (no secret scan) |
| `hk fix` | Apply fixes to modified files |
| `hk run leaks` | Scan modified files for secrets |
| `hk run leaks --all` | Scan the whole repo for secrets |
| `hk run <hook> --plan` | Show what a hook would run |
| `hk run <hook> --why` | Explain why each step and file is included or excluded |
| `hk builtins` | List builtin steps |
| `hk config dump` | Show effective settings |

## Troubleshooting

- **A global check stops running.** Look for `--from-hook` in the hook
  commands; `hk install --global` adds it back:

  ```sh
  git config --get-regexp '^hook\.hk-.*\.command'
  ```

- **Pkl errors after upgrading hk.** `config.pkl` imports the hk schema for
  a fixed version (currently `2.5.0`, matching the binary). After upgrading
  hk, set the version in both the `amends` and `import` lines to match
  `hk --version`.
- **A repo has its own `hk.pkl`.** Its hooks and steps win over global ones
  with the same name. Run `hk run <hook> --plan` in that repo to see what
  actually runs.
- **Sign-off check fails although you used `-s`.** The trailer must match
  `user.name` and `user.email` exactly. See
  [`signoff-hook.md`](signoff-hook.md#caveats).
