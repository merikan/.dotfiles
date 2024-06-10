Zellij Configuration
=====================

This [Zellij](https://github.com/zellij-org/zellij) configuration is my personal setup to mimic my Tmux config and to use Modes in a VIM-like way.

## Intro
I have been using Tmux for many years and it has worked very well. Unfortunately, there have always been a few things that have bothered me at times.
i.e. easily recognize the focused `Pane` and stay in `tmux mode` after pressing the `prefix` and then use `Esc` key to go back to `Normal` mode. 

Since I am `Vim` user, `Zellij` must not interfere with my vim keybindings, so I decided to strip down the `Normal` mode in `Zellij` to a minimum. From `Normal` mode 
you can only go to `Tmux` mode where I have my preferred bindings. From `Tmux` mode you are then able to switch to the other modes in `Zellij` such as 
`Locked`, `Pane`, `Tab`, etc. And by the way, no more `Ctrl q` by mistake in `Normal` mode

Many `Tmux` key bindings stays in `Tmux` mode so we can execute the key multiple times, just like `Normal` mode in vim.

My `Tmux` mode is more like `Normal` mode in `Vim`. My first try in `Zellij` was to use `Locked` mode as my `default` mode but but many default key bindings used 
`SwitchToMode "Normal";` after the binding is used so I decided to stay with the `Normal` mode as default.

## Features
- default mode `Normal` is stripped to a very few key bindings
- from `Normal` mode you can only go to `Tmux` mode `Ctrl+a`
- stays in `Tmux` mode, use `Esc` key to exit
- my preferred key bindings is loaded in `Tmux` mode
  - create pane (vertical/horizontal)
  - close pane
  - jump to pane (up/down/left/right)
  - create/close tab
  - switch tabs (left/right)
  - open scrollback buffer
  - and more
- Using `Nord` theme
- Changed `default` layout.
  - moved down tab bar

## Key bindings

### All modes
* `Esc` - Exit to `Normal` mode
* `Ctrl a` - Switch to `Tmux` mode

### Normal mode
* `Ctrl a` - Switch to `Tmux` mode
* `Alt h`, `Alt Left` - Focus on `Pane` to the left
* `Alt j`, `Alt Down` - Focus on `Pane` below
* `Alt k`, `Alt Up` - Focus on `Pane` above
* `Alt l`, `Alt Right` - Focus on `Pane` to the right

### Tmux mode
#### default
* `Ctrl a` - Switch to `Normal` mode
* `Enter`, `Esc` - Switch to `Normal` mode
* `?` - Show help text
* `[` - Switch to `Scroll` mode
* `]` - Open `Scrollback` buffer in `Vim`
#### Panes
* `|`, `\`,`s` - Open new `Pane` to the right
* `-`, `_` - Open new `Pane` below
* `x` - Close current `Pane`
* `z` - Toggle `Pane` to full screen
* `h` - Focus on `Pane` to the left
* `j` - Focus on `Pane` below 
* `k` - Focus on `Pane` above
* `l` - Focus on `Pane` to the right
* `o` - Focus on next `Pane`
#### Tabs
* `c` - Create a new `Tab`
* `r` - Rename a `Tab`
* `X` - Close current `Tab`
* `Shift h`, `p` - Switch to previous `Tab`
* `Shift l`, `n`,`Tab` - Switch to next `Tab`
* `<` - Move `Tab` to left
* `>` - Move `Tab` to right
* `1` - Goto `Tab` #1
* `2` - Goto `Tab` #2
* `3` - Goto `Tab` #3
* `4` - Goto `Tab` #4
* `5` - Goto `Tab` #5
* `6` - Goto `Tab` #6
* `7` - Goto `Tab` #7
* `8` - Goto `Tab` #8
* `9` - Goto `Tab` #9
#### Session
* `d` - Detach session
* `w` - Open session-manager
* `Ctrl q` - Quit current `Session`
#### Other
* `Space` - Swap to next layout
* `Ctrl p` - Switch to `Pane` mode
* `Ctrl t` - Switch to `Tab` mode
* `Ctrl r` - Switch to `Resize` mode
* `Ctrl s` - Switch to `Scroll` mode
* `Ctrl o` - Switch to `Session` mode
* `Ctrl m` - Switch to `Move` mode
