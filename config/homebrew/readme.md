
Homebrew is a package manager for MacOs. Its main focus is to handle apps to be used in the terminal.  A subproject, Homebrew Cask, which builds upon Homebrew and focuses on the installation of GUI applications.

The package manager builds software from source using "formulae", Ruby scripts constructed with Homebrew's domain specific language (DSL) for managing dependencies, downloading source files, and configuring and compiling software. Binary packages called "bottles" provide pre-built formulae with default options.



# Essential commands

* Man pages
  * `man brew`
  * `man brew-cask`
* `brew doctor` - checks for configuration issues
* `brew update` - update the formulae and Homebrew itself
* `brew outdated` -  find out what is outdated
* `brew info` - display info about given formula
* `brew install` - installs given formula
* `brew uninstall` - uninstalls given formula
* `brew search {name`} - search for both formulae and casks.
* `brew cask update`- Casks with property `auto_updates` or `version :latest` will not be upgraded
* `brew cask install` - installs given cask
* `brew cask uninstall` - uninstalls given cask


# My day to day workflow

Just `brewit`    
I have created a script that automates my brew updates.   
`brewit ` - will update, upgrade and cleanup formulae and casks

* `brew update` - Fetch the newest version of Homebrew from GitHub    
* `brew outdated` - List all outdated formulae    
* `brew upgrade` - Upgrade all outdated formulae     
* `brew cask outdated` - List all outdated casks     
* `brew cask upgrade` - Upgrade cask if possible     
* `brew cleanup --prune=10` - remove all cache files older than 10 days.     

## Versions of a application
When installing a formulae or cask, the latest version in the homebrew tap will be used. The same is true when upgrading, unless you have pinned the formula to a specific version. Casks behaves a little bit different since they usually have the ability to auto-update itself or by the user. 
