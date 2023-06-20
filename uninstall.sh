#!/usr/bin/env bash
set -euo pipefail

exiterr (){ printf "%s \n" "$@" >&2; exit 1;}

if [ "$EUID" -ne 0 ]; then
    exiterr "ERROR: Must be run as root."
fi

rm -f /usr/local/bin/backlight
echo "Intel acpi backlight tool removed."
