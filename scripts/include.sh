#!/usr/bin/env bash

### --------------------------------- ###
#    Handle errors
### --------------------------------- ###
# # exit on errors
set -o nounset # exit on use of uninitialized variable
set -o errtrace # inherits trap on ERR in function and subshell

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
    fail "Command '$command' failed at line $line - exited with status: $err" 

    if [ "$funcstack" != "::" ]; then
      if [ "$linecallfunc" != "" ]; then
        local funcErr="called at line $linecallfunc"
      fi
      echo -n "$(date) $(hostname) $0: DEBUG Error in ${funcstack} $funcErr"
    fi
    echo "'$command' failed at line $line - exited with status: $err"
}

### --------------------------------- ###
#    Print messages
### --------------------------------- ###
reset='\e[0m'           # Text Reset
red='\e[0;31m'          # Red
green='\e[0;32m'        # Green
yellow='\e[0;33m'       # Yellow
blue='\e[0;34m'         # Blue
purple='\e[0;35m'       # Purple
cyan='\e[0;36m'         # Cyan
white='\e[0;37m'        # White

heading() {
    printf "\n${white}${1:-}${reset}\n"
}

info() {
    printf "[ ${blue}..${reset} ] ${1:-}\n"
}

success() {
    printf "[ ${green}OK${reset} ] ${1:-}\n"
}

warn() {
    printf "[${yellow}WARN${reset}] ${1:-}\n"
}

fail() {
    printf "[${red}FAIL${reset}] ${1:-}\n"
    exit 1
}