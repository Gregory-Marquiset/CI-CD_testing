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

local_init

#L_COUNT=$((L_COUNT + 1))

if [ $L_COUNT -ne 0 ]; then
    L_KO=$((L_KO + 1))
    ko test
    ret
else
    L_OK=$((L_OK + 1))
    ok test
    ret
fi

local_resume