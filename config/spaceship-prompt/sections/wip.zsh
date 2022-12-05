# Do we have a wip commit?
# Check if latest commit message starts with the word 'wip'

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
SPACESHIP_WIP_SHOW="${SPACESHIP_WIP_SHOW:=true}"
SPACESHIP_WIP_ASYNC="${SPACESHIP_WIP_ASYNC=true}"
SPACESHIP_WIP_PREFIX="${SPACESHIP_WIP_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_WIP_SUFFIX="${SPACESHIP_WIP_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_WIP_SYMBOL="${SPACESHIP_WIP_SYMBOL="🚧 "}"
SPACESHIP_WIP_COLOR="${SPACESHIP_WIP_COLOR="red"}"
SPACESHIP_WIP_TEXT="${SPACESHIP_WIP_TEXT="WIP"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------
spaceship_wip() {
  [[ $SPACESHIP_WIP_SHOW == false ]] && return

  spaceship::is_git || return
  local is_wip=$(git log -n 1 --pretty=format:%s 2>/dev/null | grep -q -c -i "^wip" && echo true);

  [[ -n $is_wip ]] || return

  spaceship::section \
    --color "$SPACESHIP_WIP_COLOR" \
    --prefix "$SPACESHIP_WIP_PREFIX" \
    --suffix "$SPACESHIP_WIP_SUFFIX" \
    --symbol "${SPACESHIP_WIP_SYMBOL}" \
    "${SPACESHIP_WIP_TEXT}"
}
