# Sign-off (`git commit -s`) and the hk sign-off check

## What `-s` does

`git commit -s` appends a trailer to the end of the commit message:

```
Signed-off-by: Peter Merikan <peter@merikan.com>
```

Git builds it from `user.name` and `user.email`. No key or cryptography is
involved.

## What it means: the DCO

The trailer is your agreement to the
[Developer Certificate of Origin](https://developercertificate.org). By adding
it, you certify that you wrote the change, or otherwise have the right to
submit it under the project's open source license.

Projects that use DCO (nono, the Linux kernel, many CNCF projects, GitLab)
require it on every commit. nono documents this in `CONTRIBUTING.md`
("Sign off your commits (DCO)"), and the PR checklist checks for it. A PR
with unsigned-off commits gets asked to amend before review.

## Sign-off is not GPG signing

| | `-s` sign-off | `-S` / `commit.gpgsign` |
| --- | --- | --- |
| What it is | A text trailer in the message | A cryptographic signature on the commit |
| What it proves | Nothing technically; it is a legal statement | That the holder of the key made the commit |
| Needs a key | No | Yes (GPG or SSH) |

They are independent. A commit can have either, both, or neither.

## Why not use `-s` on every commit

- **It is a legal claim.** Signing off by habit means making that claim even
  when it is false, for example on code your employer owns and has not cleared
  for release, or code copied from a source with an incompatible license.
- **Outside DCO projects it means nothing.** CLA-based projects, private
  repos, and personal projects ignore it. It does no harm there, but it adds
  nothing either.

Always sign off in repos that require DCO, and decide case by case
everywhere else.

Git has no setting that makes `git commit` sign off by default
(`format.signOff` only affects `git format-patch`). Ways to deal with that:

- An alias, such as `git config alias.cs 'commit -s'`.
- A hook that adds the trailer automatically.
- A hook that rejects commits that lack the trailer. This catches a forgotten
  sign-off without adding it for you, which keeps the attestation a deliberate
  act. This is what the check below does.

## The hk `signoff` check

### Where it lives

A step named `signoff` under the `commit-msg` hook in the global hk config,
`~/.config/hk/config.pkl` (a symlink to `~/.dotfiles/config/hk/config.pkl`).
It applies to every repo on the machine, but only enforces in repos that opt
in. No repo's tracked files are changed.

```pkl
// Opt in per repo with: git config hk.requireSignoff true
local check_signoff = new Mapping<String, Step> {
  ["signoff"] {
    check = """
      [ "$(git config --type=bool --default=false hk.requireSignoff)" = true ] || exit 0
      want="Signed-off-by: $(git config user.name) <$(git config user.email)>"
      git interpret-trailers --parse "{{commit_msg_file}}" | grep -qxF "$want" && exit 0
      echo "missing '$want' trailer (use git commit -s)" >&2
      exit 1
      """
  }
}
hooks {
  ["commit-msg"] {
    steps = check_signoff
  }
  // ...existing hooks
}
```

### Opting a repo in

```sh
git config hk.requireSignoff true
```

This writes to the repo's `.git/config`, which all worktrees of that repo
share. To opt out again, run `git config --unset hk.requireSignoff`.

### When it runs

1. You run `git commit`.
2. After the message is written, and before the commit object is created (and
   before any GPG signing), git runs the `commit-msg` hook. The global git
   config maps that event to `hk run commit-msg "$@"`, where `$@` is the
   message file path, usually `.git/COMMIT_EDITMSG`.
3. hk runs the `signoff` step and substitutes that path for
   `{{commit_msg_file}}`.
4. If the step exits non-zero, git aborts the commit. The message stays in
   `.git/COMMIT_EDITMSG`.

It also runs for `git commit --amend`, for rewording during `git rebase`, and
for `git merge` when a merge message is written. `HK=0 git commit ...` or
`git commit --no-verify` skips it.

### What each line does

```sh
[ "$(git config --type=bool --default=false hk.requireSignoff)" = true ] || exit 0
```

Opt-in gate. If the repo has not set `hk.requireSignoff` to true, the step
passes immediately, so repos without DCO are unaffected.

```sh
want="Signed-off-by: $(git config user.name) <$(git config user.email)>"
```

Builds the exact trailer expected for the current identity.

```sh
git interpret-trailers --parse "{{commit_msg_file}}" | grep -qxF "$want" && exit 0
```

Extracts only the trailer block (the key-value lines at the end of the
message) and requires a whole-line, fixed-string match. As a result:

- the same text in the body does not count,
- comment lines are ignored,
- another person's sign-off alone does not satisfy the check.

```sh
echo "missing '$want' trailer (use git commit -s)" >&2
exit 1
```

Otherwise it prints the reason and rejects the commit.

### Why the hook command must not use `--from-hook`

`hk install --global` writes the git hook commands with `--from-hook`, for
example:

```
hook.hk-commit-msg.command = test "${HK:-1}" = "0" || hk run commit-msg --from-hook "$@"
```

With `--from-hook`, hk first looks for a project `hk.pkl`. If the repo has
none, it exits silently without running anything. It never reads the global
`~/.config/hk/config.pkl`:

```
DEBUG No config file found, using default
DEBUG no hk config found for commit-msg, skipping (--from-hook)
```

That default makes a global install safe in repos that don't use hk. In this
setup, though, the checks live in the global config and most repos have no
`hk.pkl`, so the flag turns them off. Each hk hook command in the global git
config (`~/.config/git/config`, a symlink into `~/.dotfiles/config/git/`)
therefore runs without it:

```
hook.hk-commit-msg.command = test "${HK:-1}" = "0" || hk run commit-msg "$@"
hook.hk-pre-commit.command = test "${HK:-1}" = "0" || hk run pre-commit "$@"
hook.hk-pre-push.command   = test "${HK:-1}" = "0" || hk run pre-push "$@"
```

Re-running `hk install --global` may add the flag back. If a global check
stops firing, look for `--from-hook` first:

```sh
git config --get-regexp '^hook\.hk-.*\.command'
```

### Caveats

- **The identity must match exactly.** If `user.email` differs from the
  address in the sign-off (for example, a work address configured through an
  `includeIf`), the check fails. This is intentional, since DCO checks also
  compare against the commit identity.

### Testing without creating a commit

```sh
printf 'subject\n' > /tmp/msg.txt
git hook run commit-msg -- /tmp/msg.txt; echo "exit $?"    # expect 1 in an opted-in repo

printf 'subject\n\nSigned-off-by: %s <%s>\n' "$(git config user.name)" "$(git config user.email)" > /tmp/msg.txt
git hook run commit-msg -- /tmp/msg.txt; echo "exit $?"    # expect 0
```

### Verified behavior

| Scenario | Result |
| --- | --- |
| nono (opted in), message without sign-off | Rejected |
| nono (opted in), message with sign-off | Accepted |
| Repo not opted in, `git commit` without `-s` | Committed |
| Repo opted in, `git commit` without `-s` | Rejected with `missing 'Signed-off-by: ...' trailer` |
| Repo opted in, `git commit -s` | Committed with the trailer |
