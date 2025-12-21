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

skip

local_resume
