
# Flutter

# Flutter is an open-source UI software development kit
# Link: https://flutter.dev/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
SPACESHIP_FLUTTER_SHOW="${SPACESHIP_FLUTTER_SHOW=true}"
SPACESHIP_FLUTTER_CONTEXT_ONLY="${SPACESHIP_FLUTTER_CONTEXT_ONLY=true}"
SPACESHIP_FLUTTER_PREFIX="${SPACESHIP_FLUTTER_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_FLUTTER_SUFFIX="${SPACESHIP_FLUTTER_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_FLUTTER_SYMBOL="${SPACESHIP_FLUTTER_SYMBOL="💙 "}"
SPACESHIP_FLUTTER_COLOR="${SPACESHIP_FLUTTER_COLOR="blue"}"
SPACESHIP_FLUTTER_CHANNEL_PREFIX="${SPACESHIP_FLUTTER_CHANNEL_PREFIX=" ["}"
SPACESHIP_FLUTTER_CHANNEL_SUFFIX="${SPACESHIP_FLUTTER_CHANNEL_SUFFIX="]"}"
SPACESHIP_FLUTTER_CHANNEL_COLOR="${SPACESHIP_FLUTTER_CHANNEL_COLOR="$SPACESHIP_FLUTTER_COLOR"}"

# ------------------------------------------------------------------------------
# Utils
# ------------------------------------------------------------------------------

spaceship::flutter::is_in_context() {
    local is_in_context=false

    if [[ -f pubspec.yaml || -d dart_tool || -n *.dart(#qN^/) ]]; then
      is_in_context=true
    elif spaceship::is_git; then # flutter project in git repo?
      local git_root=$(git rev-parse --show-toplevel)
      if (cygpath --version) >/dev/null 2>/dev/null; then
        git_root=$(cygpath -u $git_root)
      fi
      if [[ -f $git_root/pubspec.yaml || -d $git_root/dart_tool || -n $git_root/lib/**/*.dart(#qN^/) ]]; then
        is_in_context=true
      fi
    fi

    [[ $is_in_context == true ]]

}

# ------------------------------------------------------------------------------
# Section(s)
# ------------------------------------------------------------------------------
spaceship_myflutter() {
  [[ $SPACESHIP_FLUTTER_SHOW == false ]] && return

  spaceship::exists flutter || return

  [[ $SPACESHIP_FLUTTER_CONTEXT_ONLY == true ]] && ! spaceship::flutter::is_in_context && return

  local flutter_version_output=$(flutter --version --suppress-analytics | head -n 1)
  local flutter_version=$(echo "$flutter_version_output" | awk '{print $2}')
  local flutter_channel=$(echo "$flutter_version_output" | awk '{print $5}')
  local flutter_channel_section="$(_spaceship_flutter_channel $flutter_channel)"

  spaceship::section \
    "$SPACESHIP_FLUTTER_COLOR" \
    "$SPACESHIP_FLUTTER_PREFIX" \
    "${SPACESHIP_FLUTTER_SYMBOL}v${flutter_version}${flutter_channel_section}" \
    "$SPACESHIP_FLUTTER_SUFFIX"
}
# internal section for channel
# inparam: channel
_spaceship_flutter_channel() {
  [[ $SPACESHIP_FLUTTER_CHANNEL_SHOW == false ]] && return

  local flutter_channel=${1:?"unknown"}

  spaceship::section \
    "$SPACESHIP_FLUTTER_CHANNEL_COLOR" \
    "$SPACESHIP_FLUTTER_CHANNEL_PREFIX${flutter_channel}$SPACESHIP_FLUTTER_CHANNEL_SUFFIX"
}
