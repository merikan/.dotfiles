# Source completion files for homebrew

if command -v brew >/dev/null 2>&1; then
  # Turn on bash-completion if it's installed
  if [ -s `brew --prefix`/etc/bash_completion ]; then
    source `brew --prefix`/etc/bash_completion
    # bash-completion will complete variables (-v) for the cd command; 
    # At least on OS X it looks awful, turn it off (complete -o nospace -v -F _cd cd)
    complete -o nospace -F _cd cd
  else
    # Completion file for the brew command itself is installed but not activated 
    # by default, so we have to give it a little help. 
    # FYI: If formula bash-completion is installed it will copy this file 
    # to `brew --prefix`/etc/bash_completion.d. directory. Yes COPY, not symlink!!
    if [ -s `brew --prefix`/Library/Contributions/brew_bash_completion.sh ]; then
      source `brew --prefix`/Library/Contributions/brew_bash_completion.sh
    fi 
    
    # Most formulas put their completion files in the `brew --prefix`/etc/bash_completion.d 
    # directory. We have to source them ourseleves if formula bash-completion isn't installed
    if [ -d `brew --prefix`/etc/bash_completion.d ]; then
      for f in `brew --prefix`/etc/bash_completion.d/*; do source $f; done
    fi
  fi
fi
