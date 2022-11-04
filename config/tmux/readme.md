Tmux Configuration
=====================

This [tmux](https://tmux.github.io/) configuration uses [tmux-config](https://github.com/samoshkin/tmux-config) as base (kudos to Alexey). 
Of course I have done som modification to better fit my own environment and to prevent me from breaking any fingers when using [swedish keyboard](https://support.apple.com/en-us/HT201794) on my Macbook Pro.


Table of contents
-----------------

1. [Features](#features)
1. [General settings](#general-settings)
1. [Key bindings](#key-bindings)
1. [Nested tmux sessions](#nested-tmux-sessions)
1. [Copy mode](#copy-mode)
1. [Clipboard integration](#clipboard-integration)
1. [Themes and customization](#themes-and-customization)
1. [Status line](#status-line)
1. [Tmux Plugins](#tmux-plugins)

Features
---------

- "C-a" prefix instead of "C-b"
- send ctrl-a to the underlying shell (move to start of line)
- use vim key bindings where it's appropriate
- easy moving between panes and resize
- easy moving between windows and swapping order
- prompt to name a window before it's created
- newly created windows and panes retain current working directory
- added prompt to destructive actions
- highlight focused pane
- separate theme file for easy customizable status line
- scroll and copy mode improvements
- integration with OSX or Linux clipboard
- integration with 3rd party plugins
- install tpm and plugins automatically when tmux is started

**Copy mode**
- Using vim bindings in copy mode
   - Select visual mode; (`v`) character-wise, (`V`) line-wise or (`Ctrl+v`) block-wise
   - Yank selected text with `y`
   - Quit copy-mode with `q` or `Ctrl+c`
- Don't leave copy-mode when yanking, use 'q' or Ctrl+c to leave
- Enable cursor to select in copy-mode without leaving.
- Doble click to deselect

**Color Scheme and Status line widgets**:

- The Color Scheme is my own Base16 theme
- Using Power Line status line
- visual indicator when you press `prefix` and when in `Copy` mode
- CPU, memory usage, system load average metrics
- username and hostname, current date time
- visual indicator when pane is zoomed
- visual indicator when prefix is pressed
- online/offline visual indicator
- toggle visibility of status line

General settings
----------------
Windows and pane indexing starts from `1` rather than `0`. Scrollback history limit is set to `20000`. Automatic window renaming is turned off. Aggresive resizing is on. Message line display timeout is `1.5s`. Mouse support in `on`. 

256 color palette support is turned on, make sure that your parent terminal is configured propertly. See [here](https://unix.stackexchange.com/questions/1045/getting-256-colors-to-work-in-tmux) and [there](https://github.com/tmux/tmux/wiki/FAQ)

Key bindings
-----------
The `~/.tmux.conf` overrides default key bindings for many action, to make them more intuitive and comfortable to type on a Swedish and ANSI keyboard. Also I want to have as vim-like as possible.

The list below is not a complete list of key bindings, it only contains the bindings that I use most or which I feel I need to document.


<table style="border: 1px solid;">
    <tr>
        <td style="white-space:nowrap"><b>tmux key</b></td>
        <td><b>Description</b></td>
    </tr>
    <tr>
        <td colspan=2 style="text-align:left"><b>: General</b></td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>C+a</code></td>
        <td>Default prefix, used instead of "C-b". Same prefix is used in screen program, and it's easy to type. The only drawback of "C-a" is that underlying shell does not receive the keystroke to move to the beginning of the line. To solve this we have to press "C-a" twice.
        </td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; r</code></td>
        <td>Reload tmux configuration from ~/.tmux.conf file</td>
    </tr>
    <tr>
        <td colspan=2 style="text-align:left">: Pane</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; s</code>&nbsp;&nbsp; or<br/>
        <code>&lt;prefix&gt; |</code>&nbsp;&nbsp; or<br/>
        <code>&lt;prefix&gt; \</code>
        </td>
        <td>Split pane vertically</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; -</code>&nbsp;&nbsp; or<br/>
        <code>&lt;prefix&gt; _</code>
        </td>
        <td>Split pane horizontally</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Ctrl + [h,j,k,l]</code>&nbsp;&nbsp; or<br/>
        <code>Alt + [←,↓,↑,→]</code>
        </td>
        <td>Select pane left, down, up, right without prefix<br>
        <code>Ctrl+[hjkl]</code> is <code>vim</code> and <code>fzf</code> aware and visual effect is enabled</td>
    </tr>
        <td style="white-space:nowrap"><code>Alt+Shift + [←,↓,↑,→]</code></td>
        <td>Resize current pane to the left, down, up, right</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; Ctrl+o</code></td>
        <td>Swap current active pane with next one</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; z</code></td>
        <td>Toggle zoom for current pane</td>
    </td>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; x</code></td>
        <td>Kill current pane (with confirmation)</td>
    </tr>
    <tr>
        <td colspan=2 style="text-align:left">: Window</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; c</code></td>
        <td>Create a new window (with prompt for name)</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; n</code></td>
        <td>Rename current window</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; + [H,L]</code>&nbsp;&nbsp; or<br/><code>Shift + [←,→]</code></td>
        <td>Select window to the left/right</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; + w</code></td>
        <td>Select window from tree</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; + [<,>]</code>&nbsp;&nbsp; or<br/><code>Ctrl + Shift + [←,→]</code></td>
        <td>Move the current window to the left/right</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; X</code></td>
        <td>Kill current window (with confirmation)</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; Ctrl+x</code></td>
        <td>Kill other windows but current one (with confirmation)</td>
    </tr>
    <tr>
        <td colspan=2 style="text-align:left">: Session</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; N</code></td>
        <td>Rename current session</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; Q</code></td>
        <td>Kill current session (with confirmation)</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; d</code></td>
        <td>Detach from session</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; D</code></td>
        <td>Detach other clients except current one from session</td>
    </tr>
    <tr>
        <td colspan=2 style="text-align:left">: Copy mode (with mouse support)</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; Esc</code></td>
        <td>Enter copy mode</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>q</code>&nbsp;&nbsp; or <br/>
        <code>Ctrl+c</code></td>
        <td>exit copy mode</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>v</code></td>
        <td>Begin selection in character-wise mode</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>V</code></td>
        <td>Begin selection in line-wise mode</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Ctrl+v</code></td>
        <td>Begin selection in block-wise mode</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>y</code>&nbsp;&nbsp; or <br/>
        <code>Enter</code></td>
        <td>Copies selection without exiting copy mode</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Escape</code></td>
        <td>Clear selection</td>
    </tr>
    <tr>
        <td valign="top" style="white-space:nowrap">Movement</td>
        <td>Full support for mouse and arrow movement. <br/>Vim keys:
        <table>
            <tr>
              <td><code>hjkl</code></td>
              <td>Move cursor left/down/up/right</td>
            </tr>
            <tr>
              <td><code>w</code></td>
              <td>Move forward to the beginning of a word.</td>
            </tr>
            <tr>
              <td><code>e</code></td>
              <td>Move to the end of a word.</td>
            </tr>
            <tr>
              <td><code>b</code></td>
              <td>Move backward to the beginning of a word.</td>
            </tr>
            <tr>
              <td><code>0</code></td>
              <td>Move to the beginning of line</td>
            </tr>
            <tr>
              <td><code>$</code></td>
              <td>Move to the end of line</td>
            </tr>
            <tr>
              <td><code>g</code></td>
              <td>Move to history top</td>
            </tr>
            <tr>
              <td><code>G</code></td>
              <td>Move to history bottom</td>
            </tr>
            <tr>
              <td><code>Ctrl+b</code></td>
              <td>Scroll pageup</td>
            </tr>
            <tr>
              <td><code>Ctrl+f</code></td>
              <td>Scroll pagedown</td>
            </tr>
            </table>
        </td>
        </td>
    </tr>
    <tr>
        <td colspan=2 style="text-align:left">: Other</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; ?</code></td>
        <td>List all key bindings</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; Ctrl+t</code></td>
        <td>Toggle status bar visibility</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; m</code></td>
        <td>Monitor current window for activity</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; M</code></td>
        <td>Monitor current window for silence by entering silence period</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; Ctrl+s</code></td>
        <td>save all the details from your tmux environment (plugin: tmux-plugins/tmux-resurrect)</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; Ctrl+r</code></td>
        <td>restore all the details from your tmux environment (plugin: tmux-plugins/tmux-resurrect)</td>
    </tr>
</table>
     
## Copy mode
My key-bindings in copy-mode are vim bindings.   

To enter copy mode press `<prefix>+Esc` and to exit just press `q` or `Ctrl+c`   

Tmux copy mode is  is very similar to vim visual mode. Select start selecting in character-vise mode with `v`, line-wise mode with `S-v` and block-wise mode with `C-v`. You can also use `Space` to start selection in charactervise mode.   
To copy selected text without leaving copy mode, use `y` or `Enter`

You can also select text using mouse. Default behavior is to copy text and immediately cancel copy mode on `MouseDragEnd1Pane` event. I have changed this behaviour so text is only selected, to yank the text use `y` and exit copy mode with `q`.   
You can reset selection with mouse click.


## Themes and customization

All colors and styles for Tmux and the status-bar are loaded from a separate theme file. For many years I have designed my own theme together with
powerline. It was a fun ride but I was always bothered by having the powerline-status process running in the background so I decided to go for a 
already made theme, and their are some really god ones out there, gruvbox, nord etc.

My current color scheme is [egel/tmux-gruvbox](https://github.com/egel/tmux-gruvbox). Gruvbux is one of my favorite color schemes because it has soft colors that doesn't distract me from the content.
I have changed `pane-active-border-style` to a nicer color so that I can easily see which pane is active.

```
# load the theme
set -g @plugin 'egel/tmux-gruvbox'
set -g @tmux-gruvbox 'dark'
set-option -g pane-active-border-style fg=colour223 #fbg1
```


## Status line

My status line has a powerline look provided by the [egel/tmux-gruvbox](https://github.com/egel/tmux-gruvbox) color theme. No bright colors and just the information I need to have when in tmux.

The left part contains:   
- current session name.

The windows part contains:
- window number
- window name
- invert background color when selected

The right part of status line consists of following components:
- visual indicator when you press prefix key: `[^A]`.
- visual indicator when pane is zoomed: `[Z]`
- CPU, memory usage, system load average metrics. 
- username and hostname (invaluable when you SSH onto remote host)
- current date time
- online/offline visual indicator

You can hide status bar using `<prefix> Ctrl+t` keybinding.


Tmux Plugins   
-----------------------

To add extra functionality I have added a couple of nice plugins.   

By adding the following to the configuration, tmux will install tpm and plugins automatically when started.

```
# install tpm and plugins automatically when tmux is started
if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"
```    

### Plugins
* [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)    
Installs and loads tmux plugins.
* [tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight)   
Plugin that highlights when you press tmux prefix key
* [tmux-online-status](https://github.com/tmux-plugins/tmux-online-status)   
Tmux plugin that displays online status of your computer.
* [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)   
Tmux plugin that enhances tmux search
* [tmux-open](https://github.com/tmux-plugins/tmux-open)   
Tmux key bindings for quick opening of a highlighted file or url
* [tmux-mem-cpu-load](https://github.com/thewtex/tmux-mem-cpu-load)   
CPU, RAM, and load monitor for use with tmux
* [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)   
Persists tmux environment across system restarts.
* [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)   
Continuous saving of tmux environment. Automatic restore when tmux is started. Automatic tmux start when computer is turned on.
* [egel/tmux-gruvbox](https://github.com/egel/tmux-gruvbox)
* [sainnhe/tmux-fzf](https://github.com/sainnhe/tmux-fzf)
Use fxf to manage your tmux work environment

Gruvbox color theme configuration for Tmux


# CheatSheets
## [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)   
Tmux plugin that enhances tmux search
### Key bindings
**Search**   
`prefix + /` - regex search (strings work too)   

Example search entries:   
> `foo` - searches for string `foo`   
>`[0-9]+` - regex search for numbers   

Grep is used for searching.   
Searches are case insensitive.   

**Predefined searches**   
These starts "copycat mode" and jump to first match.
* `prefix + ctrl-f` - simple file search
* `prefix + ctrl-g` - jumping over git status files (best used after git status command)
* `prefix + alt-h` - jumping over SHA-1/SHA-256 hashes (best used after git log command)
* `prefix + ctrl-u` - url search (http, ftp and git urls)
* `prefix + ctrl-d` - number search (mnemonic d, as digit)
* `prefix + alt-i` - ip address search

**"Copycat mode" bindings**   
These are enabled when you search with copycat:   
* `n` - jumps to the next match   
* `N` - jumps to the previous match   

To copy a highlighted match:
* `Enter` - if you're using Tmux vi mode
## [tmux-open](https://github.com/tmux-plugins/tmux-open)   
Tmux key bindings for quick opening of a highlighted file or url
### Key bindings
In tmux copy mode:   
`o` - "open" a highlighted selection with the system default program. open for OS X or xdg-open for Linux.   
`ctrl-o` - open a highlighted selection with the $EDITOR   
`shift-s` - search the highlighted selection directly inside a search engine (defaults to google).   
## [tmux-mem-cpu-load](https://github.com/thewtex/tmux-mem-cpu-load)   
CPU, RAM, and load monitor for use with tmux
## [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)   
Persists tmux environment across system restarts.
### Key bindings
`prefix + ctrl-s` - save   
`prefix + ctrl-r` - restore   
## [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)   
Continuous saving of tmux environment. Automatic restore when tmux is started. Automatic tmux start when computer is turned on.
I am using this to save my tmux environment every 15 minutes so I can restore after a reboot or if I f*ck things up.

## * [sainnhe/tmux-fzf](https://github.com/sainnhe/tmux-fzf)
To launch tmux-fzf, press `prefix` + `F` (Shift+F).

