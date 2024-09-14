# Description:
#  A custom section to show if we are inside Yazi?

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
SPACESHIP_YAZI_SHOW="${SPACESHIP_YAZI_SHOW:=true}"
SPACESHIP_YAZI_ASYNC="${SPACESHIP_YAZI_ASYNC=true}"
SPACESHIP_YAZI_PREFIX="${SPACESHIP_YAZI_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_YAZI_SUFFIX="${SPACESHIP_YAZI_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_YAZI_SYMBOL="${SPACESHIP_YAZI_SYMBOL=" "}"
SPACESHIP_YAZI_COLOR="${SPACESHIP_YAZI_COLOR="blue"}"
SPACESHIP_YAZI_TEXT="${SPACESHIP_YAZI_TEXT="Yazi Terminal"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------
spaceship_yazi() {
  [[ $SPACESHIP_YAZI_SHOW == false ]] && return

  local is_yazi=false
  if [[ -v YAZI_LEVEL ]]; then
    is_yazi=true
  fi

  [[ $is_yazi == true ]] || return

  spaceship::section \
    --color "$SPACESHIP_YAZI_COLOR" \
    --prefix "$SPACESHIP_YAZI_PREFIX" \
    --suffix "$SPACESHIP_YAZI_SUFFIX" \
    --symbol "${SPACESHIP_YAZI_SYMBOL}" \
    "${SPACESHIP_YAZI_TEXT}"
}
