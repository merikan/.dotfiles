#!/bin/bash
# http://bitmote.com/index.php?post/2012/11/19/Using-ANSI-Color-Codes-to-Colorize-Your-Bash-Prompt-on-Linux


# print all colors that are available
for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done

# ANSI Colors
# There are 16 ANSI Colors, which are actually 8 colors, each having "normal"
# and "bright" intensity variants.
# Echoes a bunch of color codes to the terminal to demonstrate
# what's available. Each line is the color code of one forground color,
# out of 17 (default + 16 escapes), followed by a test use of that color
# on all nine background colors (default + 8 escapes).
T='gYw'   # The test text
# Ascii escape char is 27, Hex \x1B, Octal 033

COLOR_NAMES=('' Black Red Green Yellow Blue Magenta Cyan White)
LIGHT_DARK=('' Bright)
echo -e "\n                    \
             40m     41m     42m     43m\
     44m     45m     46m     47m";
FGS=('    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
     '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
     '  36m' '1;36m' '  37m' '1;37m')
for i in "${!FGS[@]}"
  do
  FG=${FGS[$i]// /}
  c=$((i/2))
  if [ $i -gt 2 ]; then l=$((i-2)); fi
  printf -v COLOR "%15s" "${LIGHT_DARK[$((l%2))]} ${COLOR_NAMES[$c]}"
  echo -en " $COLOR ${FGS[$i]} \033[$FG  $T  "
  for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
    do echo -en " \033[$FG\033[$BG  $T  \033[0m";
  done
  echo;
done
echo

# 256 (8-bit) Colors
# generates an 8 bit color table (256 colors) for
# reference purposes, using the \033[48;5;${val}m
# ANSI CSI+SGR (see "ANSI Code" on Wikipedia)
#
echo -en "\n   +  "
for i in {0..35}; do
  printf "%2b " $i
done

printf "\n\n %3b  " 0
for i in {0..15}; do
  echo -en "\033[48;5;${i}m  \033[m "
done

#for i in 16 52 88 124 160 196 232; do
for i in {0..6}; do
  let "i = i*36 +16"
  printf "\n\n %3b  " $i
  for j in {0..35}; do
    let "val = i+j"
    echo -en "\033[48;5;${val}m  \033[m "
  done
done

echo -e "\n"
curl -s https://gist.githubusercontent.com/merikan/a2eb47c43ec5d29cf9e72cd739eb21fa/raw/e50a28ec54188d2413518788de6c6367ffcea4f7/print256colours.sh | bash
