# hk global config: agent notes

This directory is the machine-wide [hk](https://hk.jdx.dev/) config. Every
repo on the machine runs its git hooks through it, so a broken `config.pkl`
breaks commits and pushes everywhere.

- [`README.md`](README.md): the setup, every hook and step group, and how hk
  config works. Read it before changing `config.pkl`.
- [`signoff-hook.md`](signoff-hook.md): the `signoff` step (`commit-msg`).
- [`wip-hook.md`](wip-hook.md): the `no_wip` step (`pre-push`).

## Editing

- Edit `~/.dotfiles/config/hk/config.pkl`. `~/.config/hk/config.pkl` is a
  symlink to it.
- Run `hk` directly. The binary in use is Homebrew's
  (`/opt/homebrew/bin/hk`); the mise-installed hk is an older, unused version.
- Keep steps in the `local` step-group mappings and assign or spread them
  into `hooks`. A top-level `steps` block makes hk v2 create `check`, `fix`
  and `pre-commit` hooks implicitly, which would add fixing and staging to
  every commit.
- When a step's script consumes `{{hook_stdin}}` or another template value
  that can hold shell metacharacters, feed it through a quoted heredoc, as
  `no_wip` does. hk pastes template values into the script text.
- hk runs step scripts with `errexit`. End a pipeline that may legitimately
  exit non-zero (such as a `grep` with no match) with `|| true`.

## Verifying

Test a changed config before it reaches the real location, by pointing
`HK_CONFIG_DIR` at a directory holding the new `config.pkl`:

```sh
HK_CONFIG_DIR=/path/to/dir hk check --plan          # evaluates the config, lists steps
HK_CONFIG_DIR=/path/to/dir hk run pre-commit --plan
```

Run it inside a throwaway git repo that has no `hk.pkl`, since a project
`hk.pkl` wins over the global config for same-named hooks and steps.

## Git wiring

Git events reach hk through `hook.hk-<event>.command` entries in the global
git config (`~/.dotfiles/config/git/config`). Hooks defined in config need
Git 2.54 or later; older Git ignores them and no checks run. Those commands run
`hk run <event> "$@"` without `--from-hook`; with that flag hk skips every
repo that lacks a project `hk.pkl`, which silently disables these global
checks. `hk install --global` adds the flag back, so check after running it:

```sh
git config --get-regexp '^hook\.hk-.*\.command'
```

A hook for a new git event needs both a `hooks` entry in `config.pkl` and a
matching `hook.hk-<event>.command` / `.event` pair in the git config.

## Upgrading hk

`config.pkl` pins hk's Pkl schema in its `amends` and `import` lines. When a
new binary rejects the config, set both lines to the version from
`hk --version` and re-run the `--plan` checks above.
