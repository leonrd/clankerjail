#!/usr/bin/env bash

get_tz() {
    # If TZ is already set, return it
    if [ -n "${TZ}" ]; then
        echo "${TZ}"
        return
    fi

    # macOS: readlink /etc/localtime -> .../zoneinfo/America/New_York
    if [ "$(uname)" = "Darwin" ]; then
        readlink /etc/localtime | sed 's|.*/zoneinfo/||'

    # Ubuntu/Linux: try /etc/timezone first
    elif [ -f /etc/timezone ]; then
        cat /etc/timezone

    # Fallback: parse /etc/localtime symlink (same as macOS method)
    elif [ -L /etc/localtime ]; then
        readlink /etc/localtime | sed 's|.*/zoneinfo/||'

    # Last resort
    else
        echo "UTC"
    fi
}
