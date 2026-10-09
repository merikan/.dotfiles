# Description:
#  A custom section for Lima

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
SPACESHIP_LIMA_SHOW="${SPACESHIP_LIMA_SHOW:=true}"
SPACESHIP_LIMA_ASYNC="${SPACESHIP_LIMA_ASYNC=true}"
SPACESHIP_LIMA_PREFIX="${SPACESHIP_LIMA_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_LIMA_SUFFIX="${SPACESHIP_LIMA_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_LIMA_SYMBOL="${SPACESHIP_LIMA_SYMBOL=" "}"
SPACESHIP_LIMA_COLOR="${SPACESHIP_LIMA_COLOR="yellow"}"
SPACESHIP_LIMA_TEXT="${SPACESHIP_LIMA_TEXT=""}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------
spaceship_lima() {
  [[ $SPACESHIP_LIMA_SHOW == false ]] && return
  # echo hallo > lima.txt
  spaceship::exists limactl || return

  local count
  count=$(limactl list | grep -c "Running")

  spaceship::section \
    --color "$SPACESHIP_LIMA_COLOR" \
    --prefix "$SPACESHIP_LIMA_PREFIX" \
    --suffix "$SPACESHIP_LIMA_SUFFIX" \
    --symbol "$SPACESHIP_LIMA_SYMBOL" \
    "$count"
}
