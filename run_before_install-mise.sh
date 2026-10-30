#!/bin/sh
# Install mise itself; install configured tools separately with mise install.
set -eu

mise="$HOME/.local/bin/mise"
[ -x "$mise" ] && exit 0

tmp="$(mktemp "${TMPDIR:-/tmp}/mise-install.XXXXXXXX")"
trap 'rm -f "$tmp"' 0
trap 'exit 1' HUP INT TERM

curl -fsSL https://mise.run -o "$tmp"
sh "$tmp"
if [ ! -x "$mise" ]; then
    echo "mise installer did not create $mise" >&2
    exit 1
fi
