#!/bin/sh

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$DIR/../lib.sh"

local_init

L_COUNT=$((L_COUNT + 1))

if [ $L_COUNT -ne 0 ]; then
    L_KO=$((L_KO + 1))
    ko test
else
    L_OK=$((L_OK + 1))
    ok test
fi

local_resume