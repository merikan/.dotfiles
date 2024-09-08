# zim
[Zim Framework](https://zimfw.sh/), or just `zim` is a Zsh configuration framework with blazing speed and modular extensions.

## why
Over the years I have used many different zsh frameworks, such as [prezto](https://github.com/sorin-ionescu/prezto), [oh-my-zsh](https://ohmyz.sh/), but finally settled for `zim` because it's small, fast and easy to use.

I used to jump between `zsh` and `bash` but since a number of years I use `zsh` exclusively. I then use `zim` as the plugin manager for all my zsh plugins instead of using [Sheldon](https://sheldon.cli.rs/b), which I now only use for bash.

## Usage

### Commands
```bash
Usage: zimfw <action> [-q|-v]
```
**Essiential commands**
```bash
Actions:
  clean           Clean all. Does both clean-compiled and clean-dumpfile.
  help            Print this help.
  info            Print Zim and system info.
  list            List all modules currently defined in ~/.zimrc. Use -v to also see the mod-
                  ules details.
  init            Same as install, but with output tailored to be used at terminal startup.
  install         Install new modules. Also does build, compile. Use -v to also see their
                  output, any on-pull output and skipped modules.
  uninstall       Delete unused modules. Prompts for confirmation. Use -q for quiet uninstall.
  check           Check if updates for current modules are available. Use -v to also see
                  skipped and up to date modules.
  update          Update current modules. Also does build, compile. Use -v to also see their
                  output, any on-pull output and skipped modules.
  check-version   Check if a new version of zimfw is available.
  upgrade         Upgrade zimfw. Also does compile. Use -v to also see its output.
  version         Print zimfw version.
```
### Add a module/plugin
Adding a module is as easy as adding a line in `zimrc` file
```bash
zmodule <module name>
```
and the run 
```bash
zimfw install
```

You can of course use the built-in modules but also load from local directory or external git repositories. It can then of course be a free plugin or a plugin found in oh-my-zsh.
