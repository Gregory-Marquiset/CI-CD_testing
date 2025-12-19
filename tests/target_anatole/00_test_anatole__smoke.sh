#!/bin/sh
set -eu

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$DIR/../lib.sh"

warn "Smoke test anatole: OK"
