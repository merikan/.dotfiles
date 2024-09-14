#  A custom section to show if terminal is opened inside another tool

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
SPACESHIP_INSIDE_SHOW="${SPACESHIP_INSIDE_SHOW:=true}"
SPACESHIP_INSIDE_ASYNC="${SPACESHIP_INSIDE_ASYNC=true}"
SPACESHIP_INSIDE_PREFIX="${SPACESHIP_INSIDE_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_INSIDE_SUFFIX="${SPACESHIP_INSIDE_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_INSIDE_SYMBOL="${SPACESHIP_INSIDE_SYMBOL=" "}"
SPACESHIP_INSIDE_COLOR="${SPACESHIP_INSIDE_COLOR="blue"}"
SPACESHIP_INSIDE_TEXT="${SPACESHIP_INSIDE_TEXT="Inside "}"

if [ -z "$SPACESHIP_INSIDE_ORDER" ]; then
  SPACESHIP_INSIDE_ORDER=(yazi nvim vim)
fi
# ------------------------------------------------------------------------------
# Terminal Inside Tools
# ------------------------------------------------------------------------------
spaceship_inside::yazi() {
  if [[ -v YAZI_LEVEL ]]; then
    echo "Yazi"
    return 0
  else
    return 1
  fi
}

spaceship_inside::nvim() {
if [[ -v NVIM ]]; then
  echo "Nvim"
  return 0
else
  return 1
fi
}

spaceship_inside::vim() {
if [[ -v VIM ]]; then
  echo "Vim"
  return 0
else
  return 1
fi
}

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------


spaceship_inside() {
  [[ $SPACESHIP_INSIDE_SHOW == false ]] && return

  is_inside=()
  for tool in "${SPACESHIP_INSIDE_ORDER[@]}"; do
    local inside=$(spaceship_inside::$tool)
    if [[ -n $inside ]]; then
      is_inside+=$inside
    fi
  done

  [[ ${#is_inside[@]} -eq 0 ]] && return

  spaceship::section \
    --color "$SPACESHIP_INSIDE_COLOR" \
    --prefix "$SPACESHIP_INSIDE_PREFIX" \
    --suffix "$SPACESHIP_INSIDE_SUFFIX" \
    --symbol "${SPACESHIP_INSIDE_SYMBOL}" \
    "${SPACESHIP_INSIDE_TEXT}${is_inside[@]}"

}
