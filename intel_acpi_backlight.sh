#!/usr/bin/env bash

set -euo pipefail
#set -euxo pipefail

echoerr (){ printf "%s \n" "$@" >&2;}
exiterr (){ printf "%s \n" "$@" >&2; exit 1;}

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

DEFAULT_STEP=1000
MIN_BACKLIGHT_VALUE=200
MAX_BACKLIGHT_VALUE_FILE=/sys/class/backlight/intel_backlight/max_brightness
BACKLIGHT_VALUE_FILE=/sys/class/backlight/intel_backlight/brightness

if [[ ! -f "${BACKLIGHT_VALUE_FILE}" ]]; then
    exiterr "ERROR: Incompatible system no backlight file located at: ${BACKLIGHT_VALUE_FILE}"
fi

MAX_BACKLIGHT_VALUE="$(cat "${MAX_BACKLIGHT_VALUE_FILE}")"

backlight_up(){
    local step="${1:-$DEFAULT_STEP}"

    local current_backlight_value="$(cat "${BACKLIGHT_VALUE_FILE}")"
    local backlight_value=$(( ${current_backlight_value}+$step ))
    if [[ $backlight_value -gt $MAX_BACKLIGHT_VALUE ]]; then
        backlight_value="${MAX_BACKLIGHT_VALUE}"
    fi
    echo "New backlight value: ${backlight_value}"
    echo $backlight_value > "${BACKLIGHT_VALUE_FILE}"
}

backlight_down(){
    local step="${1:-$DEFAULT_STEP}"
    
    local current_backlight_value="$(cat "${BACKLIGHT_VALUE_FILE}")"
    backlight_value=$(( ${current_backlight_value}-$step ))
    if [[ "${backlight_value}" -lt "${MIN_BACKLIGHT_VALUE}" ]]; then
        backlight_value="${MIN_BACKLIGHT_VALUE}"
    fi
    echo "New backlight value: ${backlight_value}"
    echo $backlight_value > "${BACKLIGHT_VALUE_FILE}"
}

backlight_min(){
    backlight_value="${MIN_BACKLIGHT_VALUE}"
    echo $backlight_value > "${BACKLIGHT_VALUE_FILE}"
}

backlight_max(){
    backlight_value="${MAX_BACKLIGHT_VALUE}"
    echo $backlight_value > "${BACKLIGHT_VALUE_FILE}"
}

print_backlight_state(){
    local current_backlight_value="$(cat "${BACKLIGHT_VALUE_FILE}")"
    printf " ACPI backlight min value:     %s \n" "${MIN_BACKLIGHT_VALUE}"
    printf " ACPI backlight max value:     %s \n" "${MAX_BACKLIGHT_VALUE}"
    printf " ACPI backlight current value: %s \n" "${current_backlight_value}"
}




_help() {
    cat << EOF 
NAME

   Intel backlight controller 

DESCRIPTION

    This is a simple shell script to control backlight for Intel sysfs acpi architecture. 

USAGE

    backlight -u            Increase backlight by ${DEFAULT_STEP} steps
    backlight -d            Decrease backlight by ${DEFAULT_STEP} steps
    backlight -M            Set backlight to max level of ${MAX_BACKLIGHT_VALUE} steps  
    backlight -m            Set backlight to min level of ${MIN_BACKLIGHT_VALUE} steps
    backlight -u -v 2000    Increase backlight by 2000 steps
    backlight -d -v 2000    Decrease backlight by 2000 steps


OPTIONS

    -h, --help             Print this help and exit
    -u  --backlight-up     Increase backlight by: ${DEFAULT_STEP} steps
    -d  --backlight-down   Decrease backlight by: ${DEFAULT_STEP} steps
    -M  --backlight-max    Set backlight to max level of ${MAX_BACKLIGHT_VALUE} steps  
    -m  --backlight-min    Set backlight to min level of ${MIN_BACKLIGHT_VALUE} steps
    -v, --backlight-value  Set backlight to specified value
    -s, --step             Set the step value for -u and -d   Default: ${DEFAULT_STEP}

EOF
}

function parse_params() {

    local _backlight_up=false
    local _backlight_down=false
    local _backlight_min=false
    local _backlight_max=false
    local _step="${DEFAULT_STEP}"


    while :; do
    case "${1-}" in
    -h | --help) echo "$(_help)" ;;#| less ;;
    -b | --backlight-value) # example named parameter
      backlight_value="${2-}"
      shift
      ;;
    -s | --step) # example named parameter
      step="${2-}"
      shift
      ;;
    -u | --backlight-up) _backlight_up=true;;
    -d | --backlight-down) _backlight_down=true;;
    -M | --backlight-max) _backlight_max=true;;
    -m | --backlight-min) _backlight_min=true;;
    -?*) exiterr "ERROR: Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

    args=("$@")
    
    if [ "$EUID" -ne 0 ]; then
        exiterr "ERROR: Must be run as root."
    fi

    if [ $_backlight_up == true ]; then
        backlight_up "${_step}" 
    fi
    
    if [ $_backlight_down == true ]; then
        backlight_down "${_step}" 
    fi
    
    if [ $_backlight_min == true ]; then
        backlight_min
    fi
    
    if [ $_backlight_max == true ]; then
        backlight_max
    fi
    
    print_backlight_state 

    return 0
}

parse_params "$@"

