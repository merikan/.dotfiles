# Neovim config

My Neovim setup, built on [LazyVim](https://www.lazyvim.org/) with
[lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager. LazyVim
provides the base. This repo only adds, overrides, or disables things on top.

## How I use it

- Daily editor for Java, Go, rust, Lua, shell, YAML/Kubernetes, and a lot of Markdown.
- Leader is `<Space>`. Mouse is off, clipboard is shared with the system.
- Auto-format on save is off. `<A-s>` saves without running autocmds.
- Files auto-save on `InsertLeave` and `TextChanged`.
- Git through lazygit (`<leader>gf` shows the current file's history).
- `<leader>$` opens a menu for LazyVim/Lazy/Mason housekeeping.
- `<leader>c?` shows which formatters, linters, and LSP servers are attached.
- I run Neovim inside [Zellij](https://zellij.dev/), which uses `Alt-h/j/k/l`
  to move between panes, so Neovim never gets those keys. LazyVim's
  `<A-j>`/`<A-k>` (move line) don't work there. I use `<A-S-j>`/`<A-S-k>`
  instead.

## Layout

```text
init.lua              entry point, loads config.lazy
lua/config/           options, keymaps, autocmds, lazy.nvim bootstrap
lua/plugins/          my plugin specs, grouped in coding/ editor/ lang/ util/
lua/plugins/disabled.lua   LazyVim plugins I turn off
lazyvim.json          enabled LazyVim extras
lazy-lock.json        pinned plugin versions
mason-lock.json       pinned Mason tool versions
```

## Plugin spec conventions

lazy.nvim merges every spec for the same plugin, whatever the file name. The
names are for me.

In `coding/`, `editor/`, and `util/`, files are named after a plugin:

- `extend_<plugin>.lua` only changes a plugin that LazyVim already ships, e.g.
  `extend_snacks.lua`, `extend_blink.lua`.
- `<plugin>.lua` adds a new plugin, e.g. `yazi-nvim.lua`, `auto-save.lua`.
- One override file per plugin, so all changes to a plugin live in one place.

In `lang/`, each file is a language:

- `extend_<extra>.lua` when the LazyVim extra for that language is enabled,
  named after the extra, e.g. `extend_go.lua` for `lang.go`. It holds both
  overrides and added plugins for that language.
- `extend_<language>.lua` also when there is no extra but LazyVim already
  configures the language, e.g. `extend_lua.lua` overrides its built-in lua_ls.
- `<language>.lua` when LazyVim has nothing for the language, e.g.
  `shell.lua`, `kustomize.lua`.

### Overriding `opts`: table or function

A table in `opts` is deep-merged into LazyVim's defaults, but lists are
replaced, not appended to:

```lua
-- override values: a table is fine
opts = { notifier = { style = "fancy" } }

-- this REPLACES LazyVim's ensure_installed list
opts = { ensure_installed = { "checkstyle" } }

-- add to a list: use a function and vim.list_extend
opts = function(_, opts)
  opts.ensure_installed = opts.ensure_installed or {}
  vim.list_extend(opts.ensure_installed, { "checkstyle" })
end
```

Use a table to set values, and a function when adding to a list.

Exception: keys listed in a spec's `opts_extend` are appended even from a
table. LazyVim sets this for some lists, e.g. blink.cmp's `sources.default`.
To remove an item from such a list, use a function.

## LazyVim extras

Enabled in `lazyvim.json`:

- **Coding:** mini-surround
- **Editor:** outline
- **Debug and test:** dap.core, test.core
- **LSP and tools:** neoconf, rest
- **Languages:** Go, Java, Kotlin, Rust, Dart, Nix, Terraform, Ansible
- **Config and docs:** JSON, YAML, TOML, Markdown, Git

## Plugins I add or extend

Rows marked *(extended)* ship with LazyVim. I only override their config.

### UI

| Plugin | Purpose |
| --- | --- |
| [everforest-nvim](https://github.com/neanias/everforest-nvim) | Active colorscheme (tokyonight, kanagawa, kanso, gruvbox also installed) |
| [snacks.nvim](https://github.com/folke/snacks.nvim) *(extended)* | Custom dashboard header, picker shows hidden files, fancy notifier, zoxide (`<leader>fz`) |
| [nvim-colorizer.lua](https://github.com/catgoose/nvim-colorizer.lua) | Highlight color codes (`<leader>u+c`) |

### Editing

| Plugin | Purpose |
| --- | --- |
| [blink.cmp](https://github.com/Saghen/blink.cmp) *(extended)* | Completion with Neovim-style keys, buffer source removed, signature help on (see [Completion](#completion)) |
| [auto-save.nvim](https://github.com/okuuva/auto-save.nvim) | Auto save |

### Files and buffers

| Plugin | Purpose |
| --- | --- |
| [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) | Yazi file manager (`<M-o>`, `<leader>Y`) |
| [bafa.nvim](https://github.com/mistweaverco/bafa.nvim) | Buffer switcher (`<leader>bb`) |

### Diff and review

| Plugin | Purpose |
| --- | --- |
| [codediff.nvim](https://github.com/esmuellert/codediff.nvim) | Side-by-side diff (`:CodeDiff`) |
| [codereview.nvim](https://github.com/afewyards/codereview.nvim) | Code review (`:CodeReview`) |

### Markdown

| Plugin | Purpose |
| --- | --- |
| [checkmate.nvim](https://github.com/bngarren/checkmate.nvim) | Todo lists |
| [table-nvim](https://github.com/SCJangra/table-nvim) | Table editing |
| [live-preview.nvim](https://github.com/brianhuster/live-preview.nvim) | Browser preview (`<leader>cP`) |
| [markmap.nvim](https://github.com/Zeioth/markmap.nvim) | Mind maps |
| [touchup.nvim](https://github.com/noisesfromspace/touchup.nvim) | Editing helpers |

### Languages and tooling

| Plugin | Purpose |
| --- | --- |
| [kustomize.nvim](https://github.com/Allaman/kustomize.nvim) | Kustomize helpers for YAML |
| [mason-lock.nvim](https://github.com/zapling/mason-lock.nvim) | Lockfile for Mason tools |

### Disabled

Turned off in `lua/plugins/disabled.lua`:

- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)

## Reset

```sh
rm -rf ~/.local/share/nvim ~/.cache/nvim
```

## Workflows

### Completion

[blink.cmp](https://github.com/Saghen/blink.cmp) with keys kept close to
Neovim's built-in completion (`default` preset), configured in
`lua/plugins/editor/extend_blink.lua`. Sources are LSP,
path, and snippets (no buffer words). The menu opens while typing, the first
item is preselected and inserted as you move through the list, docs open after
200 ms, and the signature popup is on.

Typical flow, in insert mode:

1. Type, e.g. `list.`, and the menu opens. Or press `<C-n>` to open it at the cursor.
2. Move with `<C-n>` / `<C-p>`. The selected item is inserted as you go.
3. Accept with `<C-y>`. `<Tab>` jumps through placeholders such as arguments.
4. Changed your mind? `<C-e>` closes the menu and undoes the insert.

#### Insert mode

| Key | Action |
| --- | --- |
| `<C-n>` / `<C-p>` | Open menu if needed, insert next / previous item |
| `<Down>` / `<Up>` | Next / previous item |
| `<C-y>` | Accept |
| `<C-e>` | Close menu and undo the inserted item |
| `<CR>` | Accept an item you picked with `<C-n>` / `<C-p>` / arrows, else a new line |
| `<C-Space>` | Open menu without inserting, press again to toggle docs |
| `<C-b>` / `<C-f>` | Scroll docs up / down |
| `<C-s>` | Toggle signature help (saves the file when there is none) |
| `<C-k>` | Digraph, as in Neovim |
| `<Tab>` / `<S-Tab>` | Next / previous snippet placeholder, otherwise a normal Tab |

#### Command line (`:` only, not `/` search)

| Key | Action |
| --- | --- |
| `<Tab>` / `<S-Tab>` | Open menu and insert next / previous item, accept a single match |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<C-y>` | Accept |
| `<C-e>` | Cancel |
| `<End>` | Hide menu |

Nothing is preselected, and ghost text shows the top match.

#### Compared to Neovim and LazyVim

"Neovim" is plain Neovim 0.12 with no completion plugin. In insert mode my
keys follow Neovim (`<C-n>`, `<C-y>`, `<C-k>`, `<C-s>`, and roughly `<CR>`), with blink's
sources, auto menu, and docs on top. The command line is unchanged from
LazyVim.

| Insert mode key | Neovim | LazyVim | Mine |
| --- | --- | --- | --- |
| Menu opens | On demand (`<C-n>`, `<C-x>...`) | While typing | While typing, or on `<C-n>` / `<C-p>` |
| `<C-Space>` | Nothing, or as `<C-@>`: insert last text and leave insert | Open menu, toggle docs | Open menu, toggle docs |
| `<C-n>` / `<C-p>` | Start completion, next / previous | Next / previous item | Open menu if needed, next / previous |
| `<Down>` / `<Up>` | Next / previous in menu, else move cursor | Next / previous item | Next / previous item |
| `<CR>` | Insert item only if picked with arrows, else line break | Accept selected item | Accept only an item you picked, else line break |
| `<C-y>` | Accept item, else copy char above | Select and accept | Select and accept |
| `<C-e>` | Close menu, else copy char below | Cancel and undo inserted item | Cancel and undo inserted item |
| `<C-b>` / `<C-f>` | - | Scroll docs | Scroll docs |
| `<Tab>` / `<S-Tab>` | Snippet jump when active, else Tab | Snippet jump, else Tab | Snippet jump, else Tab |
| `<C-k>` | Digraph | Digraph (signature help off) | Digraph |
| `<C-s>` | LSP signature help | Save file | Toggle signature help, else save file |
| `<C-x><C-o>` | LSP completion via omnifunc | LSP completion via omnifunc | LSP completion via omnifunc |
| Sources | Buffer words, LSP via omnifunc | LSP, path, snippets, buffer | LSP, path, snippets |

| Command line key | Neovim | LazyVim | Mine |
| --- | --- | --- | --- |
| Menu opens | On `<Tab>` (wildmenu) | While typing, `:` only | While typing, `:` only |
| `<Tab>` / `<S-Tab>` | Next / previous match | Open menu, insert next / previous | Open menu, insert next / previous |
| `<C-n>` / `<C-p>` | Next / previous match, else history | Next / previous item | Next / previous item |
| `<C-y>` / `<C-e>` | Accept / cancel match | Accept / cancel | Accept / cancel |

#### Neovim built-in completion

Plain Neovim keys (`:help ins-completion`, `:help cmdline-completion`). Nothing
opens automatically by default.

Insert mode. `<C-x>` starts a sub-mode, the second key picks the source:

| Keys | Completes |
| --- | --- |
| `<C-n>` / `<C-p>` | Words from the sources in `'complete'` |
| `<C-x><C-o>` | Omni completion, LSP when a server is attached |
| `<C-x><C-n>` | Words in the current file |
| `<C-x><C-l>` | Whole lines |
| `<C-x><C-f>` | File names |
| `<C-x><C-i>` | Words in the current and included files |
| `<C-x><C-]>` | Tags |
| `<C-x><C-d>` | Definitions or macros |
| `<C-x><C-k>` / `<C-x><C-t>` | `'dictionary'` / `'thesaurus'` |
| `<C-x><C-v>` | Vim command line |
| `<C-x><C-u>` | User-defined (`'completefunc'`) |
| `<C-x>s` | Spelling suggestions |
| `<C-x><C-r>` | Register contents |

In the menu, `<C-n>`/`<C-p>` move, `<C-y>` accepts, `<C-e>` cancels, and
`<C-x><C-z>` stops without changing the text. `:set autocomplete` (0.12) opens
the menu while typing.

Command line (`:`, `/`, `?`):

| Key | Action |
| --- | --- |
| `<Tab>` / `<S-Tab>` | Complete, then next / previous match |
| `<C-n>` / `<C-p>` | Next / previous match after `<Tab>`, else history |
| `<C-d>` | List all matches |
| `<C-l>` | Insert the longest common part |
| `<C-a>` | Insert all matches |

`<Tab>` also completes search patterns in `/`, `?`, `:s`, `:g`, `:v`, and
`:vim`. Type `<C-v><Tab>` for a literal tab.

Normal and visual mode have no completion, except in the `q:` command-line
window, which is a normal buffer.

In my config, blink.cmp takes over `<C-n>`, `<C-p>`, `<C-y>`, and `<C-e>` in
insert mode and on the `:` line. The `<C-x>` sub-modes still work, e.g.
`<C-x><C-l>` for whole lines. `/` and `?` search use the built-in `<Tab>`
completion.
