
#
# Go
#
# Go is an open source programming language that makes it easy
# to build efficient software.
# Link: https://golang.org/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_GOLANG_SHOW="${SPACESHIP_GOLANG_SHOW=true}"
SPACESHIP_GOLANG_CONTEXT_ONLY="${SPACESHIP_GOLANG_CONTEXT_ONLY=true}"
SPACESHIP_GOLANG_PREFIX="${SPACESHIP_GOLANG_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_GOLANG_SUFFIX="${SPACESHIP_GOLANG_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_GOLANG_SYMBOL="${SPACESHIP_GOLANG_SYMBOL="🐹 "}"
SPACESHIP_GOLANG_COLOR="${SPACESHIP_GOLANG_COLOR="cyan"}"

# ------------------------------------------------------------------------------
# Utils
# ------------------------------------------------------------------------------

spaceship::golang::is_in_context() {
    local is_in_context=false

  # If there are Go-specific files in current directory, or current directory is under the GOPATH
    if [[ -f go.mod || -d Godeps || -f glide.yaml || -n *.go(#qN^/) || -f Gopkg.toml || -f Gopkg.lock \
        || ( $GOPATH && "$PWD/" =~ "$GOPATH/" ) ]]; then
      is_in_context=true
    elif spaceship::is_git; then # golang project in git repo?
      local git_root=$(git rev-parse --show-toplevel)
      if (cygpath --version) >/dev/null 2>/dev/null; then
        git_root=$(cygpath -u $git_root)
      fi
      if [[ -f $git_root/go.mod || -f $git_root/go.sum ]]; then
        is_in_context=true
      fi
    fi

    [[ $is_in_context == true ]]

}
# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_mygolang() {
  [[ $SPACESHIP_GOLANG_SHOW == false ]] && return

  spaceship::exists go || return
  [[ $SPACESHIP_GOLANG_CONTEXT_ONLY == true ]] && ! spaceship::golang::is_in_context && return

  # Go version is either the commit hash and date like "devel +5efe9a8f11 Web Jan 9 07:21:16 2019 +0000"
  # at the time of the build or a release tag like "go1.11.4".
  # https://github.com/spaceship-prompt/spaceship-prompt/issues/610
  local go_version=$(go version | awk '{ if ($3 ~ /^devel/) {print $3 ":" substr($4, 2)} else {print "v" substr($3, 3)} }')

  spaceship::section \
    "$SPACESHIP_GOLANG_COLOR" \
    "$SPACESHIP_GOLANG_PREFIX" \
    "${SPACESHIP_GOLANG_SYMBOL}${go_version}" \
    "$SPACESHIP_GOLANG_SUFFIX"
}
