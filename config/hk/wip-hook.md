# hk `no_wip` pre-push check

Blocks `git push` when any commit being pushed has the word `WIP` in its
subject line.

## Where it lives

A step named `no_wip` under the `pre-push` hook in the global hk config,
`~/.config/hk/config.pkl` (a symlink to `~/.dotfiles/config/hk/config.pkl`).
It applies to every repo on the machine. There is no per-repo opt-in.

```pkl
// Block pushes containing commits whose subject has the word WIP (any case)
local check_wip = new Mapping<String, Step> {
  ["no_wip"] {
    check = """
      bad=$(while read -r lref lsha rref rsha; do
        case "$lsha" in *[!0]*) ;; *) continue ;; esac
        case "$rsha" in *[!0]*) git cat-file -e "$rsha^{commit}" 2>/dev/null || rsha= ;; *) rsha= ;; esac
        if [ -n "$rsha" ]; then
          git log --format='%h %s' "$rsha..$lsha"
        else
          git log --format='%h %s' "$lsha" --not --remotes
        fi
      done <<'HK_PUSH_EOF' | grep -iwF wip
      {{hook_stdin}}
      HK_PUSH_EOF
      ) || true
      [ -z "$bad" ] && exit 0
      printf 'refusing to push commits with WIP in the subject:\n%s\n' "$bad" >&2
      exit 1
      """
  }
}
hooks {
  // ...other hooks
  ["pre-push"] {
    fix = false
    stash = "git"
    steps {
      ...check_leaks
      ...check_wip
    }
  }
}
```

## When it runs

1. You run `git push`.
2. After learning the remote's state, and before updating any remote refs,
   git runs the `pre-push` hook. The global git config maps that event to `hk run pre-push "$@"`.
   Git passes the remote name and URL as arguments, and one line per pushed
   ref on stdin:

   ```
   <local ref> <local sha> <remote ref> <remote sha>
   ```

3. hk runs the `no_wip` step alongside the leak checks.
4. If any step exits non-zero, git aborts the push and nothing is sent.

`HK=0 git push ...` or `git push --no-verify` skips it.

## What it checks

For each pushed ref, only the commits the remote does not already have:

| Case | Commits checked |
| --- | --- |
| Update of an existing remote branch | `remote_sha..local_sha` |
| New remote branch, or a remote sha that isn't available locally (for example, a force-push over unfetched work) | `local_sha --not --remotes`: commits not on any remote-tracking branch |
| Branch deletion (local sha is all zeros) | Skipped |

Using `--not --remotes` for new branches means history already pushed
elsewhere, such as old commits on `main`, is not checked again.

A subject matches if it contains `wip` as a whole word, in any case:

| Subject | Result |
| --- | --- |
| `WIP: half done` | Blocked |
| `[wip] lowercase` | Blocked |
| `fix: WIP-ish change` | Blocked (`-` is a word boundary) |
| `wipe old data` | Allowed |
| `fix: real change` | Allowed |

Only the subject is checked. `WIP` in the commit body is allowed.

A blocked push prints the offending commits:

```
refusing to push commits with WIP in the subject:
19691f8 WIP: half done
```

## How the script works

```sh
bad=$(while read -r lref lsha rref rsha; do
```

Reads git's pre-push lines, one ref per iteration, and collects the output
into `bad`.

```sh
case "$lsha" in *[!0]*) ;; *) continue ;; esac
```

Skips deletions. A local sha made only of zeros means the ref is being
deleted. Matching "only zeros" instead of a fixed 40-character string also
works for SHA-256 repos.

```sh
case "$rsha" in *[!0]*) git cat-file -e "$rsha^{commit}" 2>/dev/null || rsha= ;; *) rsha= ;; esac
```

Clears `rsha` when the remote branch is new (all zeros) or when that commit
doesn't exist locally, so the next step falls back to `--not --remotes`
instead of failing on an unknown revision.

```sh
git log --format='%h %s' "$rsha..$lsha"            # existing branch
git log --format='%h %s' "$lsha" --not --remotes   # new branch / unknown remote sha
```

Lists the short hash and subject of each new commit.

```sh
done <<'HK_PUSH_EOF' | grep -iwF wip
{{hook_stdin}}
HK_PUSH_EOF
) || true
```

hk does not pass git's stdin through to steps. It exposes it only as the
`{{hook_stdin}}` template variable, which hk pastes into the script text
before running it. Branch names may contain `$` and backticks, so pasting
them into an unquoted context would allow shell injection. A quoted heredoc
(`<<'HK_PUSH_EOF'`) is never expanded by the shell. Every stdin line has four
fields, so no line can equal the terminator.

`grep -iwF wip` keeps lines containing `wip` as a whole word, case-insensitive,
as a fixed string. Short hashes are hex and can't contain `w`, `i`, or `p`, so
only the subject can match.

hk runs steps with `errexit`. When `grep` finds nothing it exits 1, which
would abort the script and block every clean push with no message.
`|| true` prevents that.

```sh
[ -z "$bad" ] && exit 0
printf 'refusing to push commits with WIP in the subject:\n%s\n' "$bad" >&2
exit 1
```

Passes if nothing matched. Otherwise prints the commits and blocks the push.

## Why the hook command must not use `--from-hook`

`hk install --global` writes the git hook commands with `--from-hook`, for
example:

```
hook.hk-pre-push.command = test "${HK:-1}" = "0" || hk run pre-push --from-hook "$@"
```

With `--from-hook`, hk first looks for a project `hk.pkl`. If the repo has
none, it exits silently without running anything. It never reads the global
`~/.config/hk/config.pkl`:

```
DEBUG No config file found, using default
DEBUG no hk config found for pre-push, skipping (--from-hook)
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

## Caveats

- **New branches with no remote-tracking refs.** In a repo where
  `git branch -r` is empty, `--not --remotes` excludes nothing, so the first
  push checks the whole history. An old WIP commit anywhere in that history
  blocks it. Use `HK=0` for that push if the commit is intentional.
- **Errors fail open.** If `git log` itself errors, it prints nothing to
  `bad`, so the push is allowed. It guards against mistakes and shouldn't be
  relied on as a security control.
- **Global scope.** It applies to every repo, including ones where WIP
  commits are normal, such as personal scratch repos. Bypass with `HK=0`
  there, or add an opt-in gate like the sign-off check's
  `hk.requireSignoff`.

## Verified behavior

Tested with real `git push` against a throwaway bare remote:

| Scenario | Result |
| --- | --- |
| New branch, clean subjects including `wipe old data` | Allowed |
| `WIP: half done` on an existing branch | Blocked |
| `[wip] lowercase` | Blocked |
| `Wip mixed case` | Blocked |
| Clean update of an existing branch | Allowed |
| New clean feature branch | Allowed |
| Branch deletion | Allowed |
| Force-push of a WIP commit | Blocked |
| Branch named `$(touch${IFS}PWNED)` with a WIP commit | Blocked, no file created |
| `HK=0 git push` with a WIP commit | Allowed |

## Testing without pushing

```sh
printf 'refs/heads/main %s refs/heads/main %s\n' \
  "$(git rev-parse HEAD)" "$(git rev-parse @{u})" \
  | hk run pre-push origin "$(git remote get-url origin)"; echo "exit $?"
```
