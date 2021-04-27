# Java

# Java is a class-based, object-oriented programming language 
# Link: https://www.java.com

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------
SPACESHIP_JAVA_SHOW="${SPACESHIP_JAVA_SHOW=true}"
SPACESHIP_JAVA_CONTEXT_ONLY="${SPACESHIP_JAVA_CONTEXT_ONLY=true}"
SPACESHIP_JAVA_PREFIX="${SPACESHIP_JAVA_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_JAVA_SUFFIX="${SPACESHIP_JAVA_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_JAVA_SYMBOL="${SPACESHIP_JAVA_SYMBOL="☕ "}"
SPACESHIP_JAVA_COLOR="${SPACESHIP_JAVA_COLOR="cyan"}"
# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------
spaceship_java() {
  [[ $SPACESHIP_JAVA_SHOW == false ]] && return

  spaceship::exists java || return

  # Show Java version only in Java context
  if [[ $SPACESHIP_JAVA_CONTEXT_ONLY == true ]]; then
    local is_in_context=false
    
    if [[ -f pom.xml || -f build.gradle || -f settings.gradle || 
          -n *.(java|jar|war|class)(#qN^/) ]]; then
      is_in_context=true
    elif spaceship::is_git; then # java project?
      local git_root=$(git rev-parse --show-toplevel)
      if (cygpath --version) >/dev/null 2>/dev/null; then
        git_root=$(cygpath -u $git_root)
      fi
      if [[ -f $git_root/pom.xml || -f $git_root/build.gradle || -f $git_root/settings.gradle ]]; then
        is_in_context=true
      fi
    fi

    [[ $is_in_context == false ]] && return

  fi

  local java_version=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')

  spaceship::section \
    "$SPACESHIP_JAVA_COLOR" \
    "$SPACESHIP_JAVA_PREFIX" \
    "${SPACESHIP_JAVA_SYMBOL}${java_version}" \
    "$SPACESHIP_JAVA_SUFFIX"
}
