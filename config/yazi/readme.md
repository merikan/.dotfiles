# [sxyazi/yazi: 💥 Blazing fast terminal file manager written in Rust, based on async I/O.](https://github.com/sxyazi/yazi)

`yazi` is now my preferred file manager in any OS.

It has a lot amazing features without being bloated, such as image preview, tabs, plugins, themes etc.

## Usage

When I'm in the terminal, I use it like a regular cli to manage files and directories,
or to jump to a specific directory. Since `yazi' is so universal and lightweight,
I also use it in Neovim with the [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) plugin 
to manage files and directories, or just to open a file outside my project.

I also use it as my preferred File Manager, and it's not just because Finder is such a bad
software, but because in Yazi I feel at home and efficient. I then open Yazi inside
Neovide via a keyboard shortcut.

## Configuration

### Plugins

I am using the following plugins:

- [parent-arrow.yazi](plugins/parent-arrow-yazi) - Navigate parent directory up/down with `Shift+[j/k]`
- [Reledia/glow.yazi: Glow preview plugin for yazi](https://github.com/Reledia/glow.yazi)
- [yazi-rs/max-preview.yazi](https://github.com/yazi-rs/plugins/blob/main/max-preview.yazi) - Maximize or restore the preview pane.
- [yazi-rs/hide-preview.yazi](https://github.com/yazi-rs/plugins/blob/main/hide-preview.yazi) - Switch the preview pane between hidden and shown.
- [yazi-rs/git.yazi](https://github.com/yazi-rs/plugins/blob/main/git.yazi) - Show the status of Git file changes as linemode in the file list.
- [yazi-rs/smart-filter.yazi](https://github.com/yazi-rs/plugins/blob/main/smart-filter.yazi) - Makes filters smarter: continuous filtering, automatically enter unique directory, open file on submitting.

Yazi comes with a [package manager](https://yazi-rs.github.io/docs/plugins/overview) and some nice [plugins](https://github.com/yazi-rs/plugins). There are also a lot of third party plugins available.

### Essential commands

All commands to manage plugins can be found in the [Package Manager Documentation](https://yazi-rs.github.io/docs/cli#package-manager)

You can manage your plugins and flavors using the `ya pkg` subcommands:

```bash
$ ya pkg --help
Manage packages

Usage: ya pkg <COMMAND>

Commands:
  add      Add packages
  delete   Delete packages
  install  Install all packages
  list     List all packages
  upgrade  Upgrade all packages
  help     Print this message or the help of the given subcommand(s)
```

#### install a plugin

```
ya pkg add < owner/my-plugin >
```

and it will automatically clone them from GitHub, copy them to your plugins directory, and update the `package.toml` to lock their versions:

#### list all plugins

```
ya pkg list
```

#### install all the plugins with locked versions from `package.toml`

```
ya pkg install 
```

#### upgrade all the plugins to the latest version

```
ya pkg upgrade
```

and the `package.toml` will reflect the update. Add and commit.

#### pin a plugin to a specific version

```diff
[plugin]
  deps = [
-	  { use = "owner/my-plugin", rev = "9a1129c" }
+	  { use = "owner/my-plugin", rev = "=9a1129c" }
  ]
```
