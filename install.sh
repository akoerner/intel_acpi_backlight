#!/usr/bin/env bash
set -euo pipefail

exiterr (){ printf "%s \n" "$@" >&2; exit 1;}

if [ "$EUID" -ne 0 ]; then
    exiterr "ERROR: Must be run as root."
fi

if [[ -f "intel_acpi_backlight.sh" ]]; then 
    cp intel_acpi_backlight.sh /usr/local/bin/backlight
else
   curl -o /usr/local/bin/backlight https://raw.githubusercontent.com/akoerner/intel_acpi_backlight/master/intel_acpi_backlight.sh 
fi

chmod +x /usr/local/bin/backlight
echo "Intel acpi backlight tool installed"
echo "  use 'backlight --help' for more info"
