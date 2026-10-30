#!/bin/sh
# Fetch the age key before asking chezmoi to decrypt files.
set -eu

key="$HOME/.config/chezmoi/key.txt"
[ -s "$key" ] && exit 0

umask 077
mkdir -p "$(dirname "$key")"
tmp="$(mktemp "$key.tmp.XXXXXXXX")"
trap 'rm -f "$tmp"' 0
trap 'exit 1' HUP INT TERM

op read --account JF3PQH3C6FAA3D3KNN6BYSN3XU "op://osd4kgoldxrcodghtgcnptqsvy/slin24iodrktqhvdwo5dy3qzyy/notesPlain" > "$tmp"
if ! grep -q '^AGE-SECRET-KEY-' "$tmp"; then
    echo "1Password item has no age secret key" >&2
    exit 1
fi
mv "$tmp" "$key"
