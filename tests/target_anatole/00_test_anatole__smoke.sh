#!/bin/sh

SELF="${TEST_FILE:-$0}"
NAME="${SELF##*/}"
T_DIR="$(CDPATH= cd -- "$(dirname -- "$SELF")" && pwd)"

ROOT="$T_DIR/.."

LOG_LIB_FILE="$ROOT/lib/lib.sh"
. "$LOG_LIB_FILE"

local_init

HTTPS="https://www.google.com/"

#L_SKIP=$((L_SKIP + 1))

logs wait https test
wait_https $HTTPS
ret

logs https health test
https_get_health $HTTPS
ret

logs https headers test
https_get_headers $HTTPS
ret

logs https body test
https_get_body $HTTPS
ret

local_resume
