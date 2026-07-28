# dmg

A generic [mise](https://mise.jdx.dev) backend plugin for installing macOS
`.dmg` releases straight from GitHub. Point it at any `owner/repo` that
publishes a `.dmg` asset on its GitHub releases and mise will download,
mount, and extract the `.app` bundle - no per-tool plugin needed.

## Usage

```
mise use dmg:block/buzz@latest
mise use dmg:block/buzz@0.3.45
```

The tool name after `dmg:` is the GitHub `owner/repo`. Versions are the
repo's release tags (with or without a leading `v`).

Once installed, the `.app` bundle's `Contents/MacOS` directory is put on
`PATH`, so any CLI binaries bundled inside the app (e.g. `buzz`,
`buzz-desktop`) become directly runnable. The app is also copied into
`/Applications`, so it shows up in Spotlight/Launchpad and can be opened
normally (`open /Applications/Buzz.app`).

## What it does

- **`backend_list_versions`** - lists non-draft GitHub releases as available versions.
- **`backend_install`**:
  1. Looks up the release for the requested tag via the GitHub API.
  2. Finds the first `.dmg` asset in that release and downloads it.
  3. Mounts the `.dmg` with `hdiutil`, copies the `.app` bundle(s) into mise's
     install directory, then unmounts and cleans up the temp files.
  4. Writes `installed_receipt.json` into the install directory, similar to
     Homebrew's per-keg `INSTALL_RECEIPT.json`, recording the repo, version,
     and install timestamp.
- **`backend_exec_env`**:
  1. Finds the `Contents/MacOS` directory inside the installed `.app` and
     puts it on `PATH`.
  2. Keeps the `.app` copied into `/Applications`, like Homebrew Cask,
     guarded by a sibling receipt
     (`/Applications/<App>.app.installed_receipt.json`) so mise never
     clobbers an app it didn't install. This runs here rather than in
     `backend_install` because it's the hook mise actually re-invokes on
     every `mise use`/shell activation - `backend_install` only fires on a
     genuinely fresh install, so an already-installed-but-not-yet-copied
     tool would never get copied otherwise. It's best-effort (never fails
     env computation) and cheap once synced:
     - Target's receipt already matches this repo+version -> a single file
       read confirms it, nothing else happens.
     - Nothing at the target -> copies it and writes the receipt.
     - Target has a receipt for a different version (mise put it there
       before) -> replaced, receipt rewritten.
     - Target exists (even as a dangling symlink) with no receipt at all ->
       left completely untouched, a warning is printed instead, and no
       receipt is written.

Both receipts look the same:

```json
{
  "repo": "block/buzz",
  "version": "0.3.45",
  "installed_at": "2026-07-28T09:39:16Z"
}
```

## Verbose logging

Every step above logs through mise's own `log` module (`require("log")`,
already provided by mise's Lua runtime - not something this plugin adds),
so it follows mise's normal verbosity conventions with no extra flag of its
own:

```
mise install --verbose dmg:block/buzz@latest
MISE_VERBOSE=1 mise install dmg:block/buzz@latest
```

Warnings (e.g. an unmanaged `/Applications` conflict) always show regardless
of verbosity; the step-by-step detail (release lookup, download URL, mount
point, `/Applications` sync decision per app, etc.) only shows under
`--verbose`/`MISE_VERBOSE=1`. Output is prefixed `[dmg]`.

## Caveats

- Only works on macOS (relies on `hdiutil`).
- Picks the _first_ `.dmg` asset in the release. If a release ships more
  than one `.dmg` (e.g. separate Intel/Apple Silicon builds), check the
  order of assets in the GitHub release - there's no architecture-aware
  selection.
- mise caches `backend_exec_env` results to disk, keyed by (among other
  things) the install path - so a version you've never activated before
  always gets a fresh run (and gets copied), but if you edit this plugin's
  Lua files directly, already-cached tool versions may not immediately
  re-run against your changes until that cache is invalidated (e.g. `mise
cache clear`).
- mise's backend plugin API has no uninstall hook, so `mise uninstall`ing
  the version currently copied into `/Applications` doesn't remove it or
  its receipt - they're left in place until the next sync of the same tool.
- The copy in `/Applications` is unsigned/ad-hoc, so Gatekeeper may still
  prompt the first time you open it.

## Development

`lib/versions.lua` (GitHub releases -> mise version list ordering),
`lib/receipt.lua` (`installed_receipt.json` contents), and `lib/appdir.lua`
(the `/Applications` copy + receipt guard) have plain-Lua tests that don't
require mise or a running install:

```
lua tests/versions_test.lua
lua tests/receipt_test.lua
lua tests/appdir_test.lua
```
