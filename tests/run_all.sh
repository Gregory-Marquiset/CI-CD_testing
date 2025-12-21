#!/bin/sh

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$DIR/lib.sh"

clear

global_init

test $G_SKIP

require_cmd curl
require_cmd grep

log "Lancement des tests depuis: $DIR"
separator
ret

for _t in "$DIR"/*/[0-9][0-9]_test_*.sh; do
	[ -f "$_t" ] || continue
	G_COUNT=$((G_COUNT + 1))
	log "→ RUN $(basename "$_t")"
	if sh "$_t"; then
		G_PASS=$((G_PASS + 1))
		info "← PASS $(basename "$_t")"
	else
		G_FAIL=$((G_FAIL + 1))
		info "← FAIL $(basename "$_t")"
	fi
	separator
	ret
done

if [ "$G_COUNT" -eq 0 ]; then
	warn "Aucun test trouvé."
	exit 0
fi

global_resume
