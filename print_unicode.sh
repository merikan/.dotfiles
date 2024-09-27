#!/bin/sh
# print all unicode characters

export BASHOPTS=xpg_echo

from=0000 to=ffff
from=$(printf '%d' "0x$from") to=$(printf '%d' "0x$to")
while test "$from" -le "$to"; do
    num=$(printf '%04x' "$from")
    bash -c "echo -n \"\u$num\""
    from=$((from+1))
done
