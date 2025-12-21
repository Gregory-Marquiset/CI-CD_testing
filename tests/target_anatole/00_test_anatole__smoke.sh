#!/bin/sh

SELF="${TEST_FILE:-$0}"
NAME="${SELF##*/}"
DIR="$(CDPATH= cd -- "$(dirname -- "$SELF")" && pwd)"

if [ -n "${TEST_ROOT:-}" ] && [ -f "$TEST_ROOT/lib.sh" ]; then
    . "$TEST_ROOT/lib.sh"
else
    . "$DIR/../lib.sh"
    global_init
fi

HTTPS="https://www.google.com/"

local_init

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
