# do we have a wip commit?
# check if latest commit has the word 'wip' in commit message

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
SPACESHIP_WIP_SHOW="${SPACESHIP_WIP_SHOW:=true}"
SPACESHIP_WIP_PREFIX="${SPACESHIP_WIP_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_WIP_SUFFIX="${SPACESHIP_WIP_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_WIP_SYMBOL="${SPACESHIP_WIP_SYMBOL="🚧 "}"
SPACESHIP_WIP_TEXT="${SPACESHIP_WIP_TEXT="WIP"}"
SPACESHIP_WIP_COLOR="${SPACESHIP_WIP_COLOR="red"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------
spaceship_wip() {
  [[ $SPACESHIP_WIP_SHOW == false ]] && return
  
  spaceship::is_git || return

  local wip=$(git log -n 1 2>/dev/null | grep -q -c -i "wip" && echo true); 

  if [[ $wip == true ]]; then
    # Display WIP section
    spaceship::section \
      "$SPACESHIP_WIP_COLOR" \
      "$SPACESHIP_WIP_PREFIX" \
      "${SPACESHIP_WIP_SYMBOL}${SPACESHIP_WIP_TEXT}" \
      "$SPACESHIP_WIP_SUFFIX"
  fi
}