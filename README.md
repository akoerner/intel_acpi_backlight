# Intel sysfs ACPI Backlight Controller

This is s simple shell script to control Intel based display backlights via acpi
and sysfs

## Prerequisites
There are **no** special dependencies other then bash and curl for installation.

## Installation
To install the Intel acpi backlight tool run the following command:
```bash
curl -sSL https://raw.githubusercontent.com/akoerner/intel_acpi_backlight/master/install.sh | sudo bash -
```
## Uninstallion
To uninstall the Intel acpi backlight tool run the following command:
```bash
curl -sSL https://raw.githubusercontent.com/akoerner/intel_acpi_backlight/master/uninstall.sh | sudo bash -
```

> :warning: **Warning!**: Never run shell scripts that you do not trust especially as root!


## Comments
This will probably work on other systems, as well as, with minimal modification 
I just have no way of testing it. The "max" blacklight file 
(MAX_BACKLIGHT_VALUE_FILE) and "blacklight" file (BACKLIGHT_VALUE_FILE) will 
need to be autodiscovered. Pull requests are welcome.
