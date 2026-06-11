# `hk` Configuration & Agent Instructions

This directory (`~/.config/hk`) contains the global configuration for
[hk](https://hk.jdx.dev/), which acts as the default/global Git hook manager
across all repositories on this machine.

## Architecture & Global Setup

- **Global Hook Execution:** Git hooks are globally configured via
  `~/.config/git/hook.gitconfig` (which sets `hook.hk-<event>.command`). This
  intercepts git events across _all_ repositories and runs them using
  `mise x -- hk run <event> --from-hook "$@"`.
- **Global `hkrc`:** The file `config.pkl` in this directory is written in
  Apple's [Pkl](https://pkl-lang.org/) language. It acts as the global `hkrc`,
  defining a standard set of linters, formatters, and steps (e.g., `pre-commit`,
  `commit-msg`).
- **Universal Application:** Even when hooks aren't explicitly configured
  per-repo (via a local `hk.pkl`), this global hook setup and `config.pkl` serve
  as the default git hook handler.

## Bypassing & Troubleshooting

- **Bypassing Hooks:** To bypass hooks for a single git command, prefix it with
  `HK=0` (e.g., `HK=0 git commit` in bash, or `$env:HK=0; git commit` in
  PowerShell).
- **Pkl Version Panics / Eval Errors:** `config.pkl` imports specific versions
  of `hk`'s standard library (e.g., `@1.44.2`). If the `hk` binary is upgraded
  via `mise` (e.g., to `1.47.0`), you may encounter Pkl evaluation errors (like
  `key not found` or panics). When encountering these, update the version
  strings in `config.pkl`'s `amends` and `import` lines to match
  `mise x -- hk --version`.

## Key Commands

Always execute `hk` through `mise` (`mise x -- hk ...`) to ensure the correct
tool environment:

- `mise x -- hk check`: Run checks (linters) against modified files.
- `mise x -- hk fix`: Run fixes (formatters & autofixers) against modified
  files.
- `mise x -- hk check --all`: Lint all files in the current repository.
- `mise x -- hk run <hook-name>`: Explicitly test a hook (e.g., `pre-commit`)
  without going through Git.
- `mise x -- hk init`: Initialize a new local `hk.pkl` in a repository if local
  overrides are needed.

## Modifying Global Rules

- **Adding/Editing Linters:** Update the `linters` mapping inside `config.pkl`.
  Standard linters can be referenced from `Builtins` (e.g., `Builtins.ruff`).
- **Hook Mapping:** The `hooks` block in `config.pkl` ties linters to specific
  git events or custom run steps (like the `fix` and `check` commands).
