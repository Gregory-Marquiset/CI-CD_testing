#!/bin/sh

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$DIR/../lib.sh"

local_init

warn empty test 00_berthe

local_resume