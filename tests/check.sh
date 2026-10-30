#!/bin/sh
set -eu

cd "$(dirname "$0")/.."
for tool in chezmoi python3 fish shellcheck; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "Missing check dependency: $tool" >&2
        exit 1
    }
done
exec python3 tests/check.py
