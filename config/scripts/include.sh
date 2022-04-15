#!/usr/bin/env bash

### --------------------------------- ###
#    Handle errors
### --------------------------------- ###
# to use this, copy to your script
#set -o nounset # exit on use of uninitialized variable
#set -o errtrace # inherits trap on ERR in function and subshell

trap 'traperror $? $LINENO $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]:-})' ERR
#trap 'trapexit $? $LINENO' EXIT

function trapexit() {
  fail "$(date) $(hostname) $0: EXIT on line $2 (exit status $1)"
}

function traperror () {
    local err=$1 # error status
    local line=$2 # LINENO
    local linecallfunc=$3
    local command="$4"
    local funcstack="$5"

    if [ "$funcstack" != "::" ]; then
      if [ "$linecallfunc" != "" ]; then
        local funcErr="called at line $linecallfunc"
      fi
      error "$(date) $(hostname) $0: DEBUG Error in ${funcstack} $funcErr"
    fi
    fail "Command '$command' failed at line $line - exited with status: $err" 
}

### --------------------------------- ###
#    Print messages
### --------------------------------- ###
reset='\033[0m'           # Text Reset
red='\033[0;31m'          # Red
green='\033[0;32m'        # Green
yellow='\033[0;33m'       # Yellow
blue='\033[0;34m'         # Blue
purple='\033[0;35m'       # Purple
cyan='\033[0;36m'         # Cyan
white='\033[0;37m'        # White

println() {
    printf -- "${1:-}\n"
}
heading() {
    printf -- "\n${white}${1:-}${reset}\n"
}

info() {
    printf -- "[ ${blue}..${reset} ] ${1:-}\n"
}

success() {
    printf -- "[ ${green}OK${reset} ] ${1:-}\n"
}

warn() {
    printf -- "[${yellow}WARN${reset}] ${1:-}\n"
}

error() {
    printf -- "[${red}FAIL${reset}] ${1:-}\n"
}

fail() {
    error ${1:-}
    exit 1
}