#!/usr/bin/env bash
set -euo pipefail

# Discover the Docker Engine sockets under ~/.lima and ping /_ping on each.

# Collect docker.sock paths into an array (handles spaces/newlines in paths).
socks=()
while IFS= read -r -d '' s; do
  socks+=("$s")
done < <(find "$HOME/.lima" -type s -name docker.sock -print0 2>/dev/null)

if [ "${#socks[@]}" -eq 0 ]; then
  echo "No docker.sock found under $HOME/.lima" >&2
  exit 1
fi

for s in "${socks[@]}"; do
  echo "== $s"
  rc=0
  curl -sS --max-time 5 --unix-socket "$s" http://localhost/_ping || rc=$?
  echo " (exit $rc)"
done
