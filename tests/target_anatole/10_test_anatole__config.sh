#!/bin/sh

SELF="${TEST_FILE:-$0}"
NAME="${SELF##*/}"
T_DIR="$(CDPATH= cd -- "$(dirname -- "$SELF")" && pwd)"

ROOT="$T_DIR/.."

LOG_LIB_FILE="$ROOT/lib/lib.sh"
. "$LOG_LIB_FILE"

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