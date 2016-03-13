# Completion for brew command is installed but not turned on by default,
# so we have to give it a little help
if command -v brew >/dev/null 2>&1; then
  if [ -f `brew --prefix`/Library/Contributions/brew_bash_completion.sh ]; then
    . `brew --prefix`/Library/Contributions/brew_bash_completion.sh
  fi
fi
