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
- support for nested tmux sessions
- merge current session with existing one (move all windows)
- local vs remote specific session configuration
- integration with OSX or Linux clipboard (works for local, remote, and local+remote nested session scenario)
- renew tmux and shell environment (SSH_AUTH_SOCK, DISPLAY, SSH_TTY) when reattaching back to old session
- monitor windows for activity/silence
- integration with 3rd party plugins
- install tpm and plugins automatically when tmux is started
- and other stuff

**Status line widgets**:

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
The `~/.tmux.conf` overrides default key bindings for many action, to make them more intuitive and comfortable to type on a Swedish keyboard. Also I want to have as vim-like as possible.

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
        <td style="white-space:nowrap"><code>&lt;prefix&gt; s</code></td>
        <td>Split pane horizontally</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; v</code></td>
        <td>Split pane vertically</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Alt + ←</code>&nbsp;&nbsp; or<br/>
        <code>Alt + h</code>
        </td>
        <td>Select pane on the left</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Alt + →</code>&nbsp;&nbsp; or<br/>
        <code>Alt - l</code>
        </td>
        <td>Select pane on the right</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Alt + ↑</code>&nbsp;&nbsp; or<br/>
        <code>Alt + j</code>
        </td>
        <td>Select pane above</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Alt + ↓</code>&nbsp;&nbsp; or <br/>
        <code>Alt + k</code></td>
        <td>Select pane below</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Alt+Shift + ←</code></td>
        <td>Resize current pane to the left</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Alt+Shift + →</code></td>
        <td>Resize current pane to the right</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Alt+Shift + ↑</code></td>
        <td>Resize current pane up</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Alt+Shift + ↓</code></td>
        <td>Resize current pane down</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>&lt;prefix&gt; \</code></td>
        <td>Swap panes back and forth with 1st pane. When in main-horizontal or main-vertical layout, the main panel is always at index 1. This keybinding let you swap secondary pane with main one, and do the opposite.</td>
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
        <td style="white-space:nowrap"><code>Shift + →</code></td>
        <td>Move to next window</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Shift + ←</code></td>
        <td>Move to previous window</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Ctrl + Shift + →</code></td>
        <td>Move the current window to the right</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Ctrl + Shift + ←</code></td>
        <td>Move the current window to the left</td>
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
        <td style="white-space:nowrap"><code>&lt;prefix&gt; L</code></td>
        <td>Link window from another session by entering target session and window reference</td>
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
        <td style="white-space:nowrap"><code>&lt;prefix&gt; Ctrl+u</code></td>
        <td>Merge current session with another. Essentially, this moves all windows from current session to another one</td>
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
        <td colspan=2 style="text-align:left">: Copy mode (full mouse support, see below)</td>
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
        <td style="white-space:nowrap"><code>v</code>&nbsp;&nbsp; or <br/>
        <code>Space</code></td>
        <td>Begin selection</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>y</code>&nbsp;&nbsp; or <br/>
        <code>Enter</code></td>
        <td>Copies selection and exits copy mode</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>Y</code></td>
        <td>Copies the whole line</td>
    </tr>
    <tr>
        <td style="white-space:nowrap"><code>D</code></td>
        <td>Copies to the end of line</td>
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
        <td style="white-space:nowrap"><code>&lt;prefix&gt; F12</code></td>
        <td>Switch off all key binding and prefix hanling in current window. See "Nested sessions" paragraph for more info</td>
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
There are some tweaks to copy mode and scrolling behavior, you should be aware of.

There is a root keybinding to enter Copy mode: `Escape`. Once in copy mode, you have several scroll controls:

- scroll by line: `M-Up`, `M-down`
- scroll by half screen: `M-PageUp`, `M-PageDown`
- scroll by whole screen: `PageUp`, `PageDown`
- scroll by mouse wheel, scroll step is changed from `5` lines to `2`

`Space` starts selection, `Enter` copies selection and exits copy mode. List all items in copy buffer using `prefix C-p`, and paste most recent item from buffer using `prexix p`.

`y` just copies selected text and is equivalent to `Enter`,  `Y` copies whole line, and `D` copies by the end of line.

Also, note, that when text is copied any trailing new lines are stripped. So, when you paste buffer in a command prompt, it will not be immediately executed.

You can also select text using mouse. Default behavior is to copy text and immediately cancel copy mode on `MouseDragEnd` event. This is annoying, because sometimes I select text just to highlight it, but tmux drops me out of copy mode and reset scroll by the end. I've changed this behavior, so `MouseDragEnd` does not execute `copy-selection-and-cancel` action. Text is copied, but copy mode is not cancelled and selection is not cleared. You can then reset selection by mouse click.


## Clipboard integration

When you copy text inside tmux, it's stored in private tmux buffer, and not shared with system clipboard. Same is true when you SSH onto remote machine, and attach to tmux session there. Copied text will be stored in remote's session buffer, and not shared/transported to your local system clipboard. And sure, if you start local tmux session, then jump into nested remote session, copied text will not land in your system clipboard either.

This is one of the major limitations of tmux, that you might just decide to give up using it. Let's explore possible solutions:

- share text with OSX clipboard using **"pbcopy"**
- share text with OSX clipboard using [reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard) wrapper to access "pbcopy" from tmux environment (seems on OSX 10.11.5 ElCapitan this is not needed, since I can still access pbcopy without this wrapper).
- share text with X selection using **"xclip"** or **"xsel"** (store text in primary and clipboard selections). Works on Linux when DISPLAY variable is set.

All solutions above are suitable for sharing tmux buffer with system clipboard for local machine scenario. They still does not address remote session scenarios. What we need is some way to transport buffer from remote machine to the clipboard on the local machine, bypassing remote system clipboard.

There are 2 workarounds to address remote scenarios.

Use **[ANSI OSC 52](https://en.wikipedia.org/wiki/ANSI_escape_code#Escape_sequences)** escape [sequence](https://blog.vucica.net/2017/07/what-are-osc-terminal-control-sequences-escape-codes.html) to talk to controlling/parent terminal and pass buffer on local machine. Terminal should properly undestand and handle OSC 52. Currently, only iTerm2 and XTerm support it. OSX Terminal, Gnome Terminal, Terminator do not.

Second workaround is really involved and consists of [local network listener and SSH remote tunneling](https://apple.stackexchange.com/a/258168):

- SSH onto target machine with remote tunneling on
    ```
    ssh -R 2222:localhost:3333  alexeys@192.168.33.100
    ```
- When text is copied inside tmux (by mouse, by keyboard by whatever configured shortcut), pipe text to network socket on remote machine
    ```
    echo "buffer" | nc localhost 2222
    ```
- Buffer will be sent thru SSH remote tunnel from port `2222` on remote machine to port `3333` on local machine.
- Setup a service on local machine (systemd service unit with socket activation), which listens on network socket on port `3333`, and pipes any input to `pbcopy` command (or `xsel`, `xclip`).

This tmux-config does its best to integrate with system clipboard, trying all solutions above in order, and falling back to OSC 52 ANSI escape sequences in case of failure. 

On OSX you might need to install `reattach-to-user-namespace` wrapper: `brew install reattach-to-user-namespace`, and make sure OSC 52 sequence handling is turned on in iTerm. (Preferences -> General -> Applications in Terminal may access clipboard).

On Linux, make sure `xclip` or `xsel` is installed. For remote scenarios, you would still need to setup network listener and use SSH remote tunneling, unless you terminal emulators supports OSC 52 sequences.


## Nested tmux sessions

One prefers using tmux on local machine to supercharge their terminal emulator experience, other use it only for remote scenarios to retain session/state in case of disconnect. Things are getting more complex, when you want to be on both sides. You end up with nested session, and face the question: **How you can control inner session, since all keybindings are caught and handled by outer session?**. Community provides several possible solutions.

The most common is to press `C-a` prefix twice. First one is caught by local session, whereas second is passed to remote one. Nothing extra steps need to be done, this works out of the box. However, root keytable bindings are still handled by outer session, and cannot be passed to inner one.

<!-- TODO fix toggle on and off -->
Accepted solution, turn off all keybindings and key prefix handling in outer session, when working with inner one. This way, outer session just sits aside, without interfering keystrokes passed to inner session. Credits to [http://stahlke.org/dan/tmux-nested/](http://stahlke.org/dan/tmux-nested/) and this [Github issue](https://github.com/tmux/tmux/issues/237)

So, how it works. When in outer session, simply press `F12` to toggle off all keybindings handling in outer session. Now work with inner session using the same keybinding scheme and same keyprefix. Press `F12` to turn on outer session back.

<!-- ![nested sessions](https://user-images.githubusercontent.com/768858/33151636-84a0bab2-cfe1-11e7-9d5d-412525689c9b.gif) -->

You might notice that when key bindings are "OFF", special `[OFF]` visual indicator is shown in the status line, and status line changes its style (colored to gray).

###  Local and remote sessions

Remote session is detected by existence of `$SSH_CLIENT` variable. When session is remote, following changes are applied:
- status line is docked to bottom; so it does not stack with status line of local session
- some widgets are removed from status line: battery, date time. The idea is to economy width, so on wider screens you can open two remote tmux sessions in side-by-side panes of single window of local session.

You can apply remote-specific settings by extending `~/.tmux/.tmux.remote.conf` file.


## Themes and customization

All colors and styles for the status-bar are loaded from a separate theme file.

```
# load the theme
source-file ~/.tmux/tmux-theme.conf
```

## Status line

My status line is minimalistic since I don't want it to distract me from what's important. No bling bling and colors, just the information I need to have when in tmux.

The left part contains only current session name.

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
