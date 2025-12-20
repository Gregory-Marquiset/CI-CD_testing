#!/bin/sh
set -eu

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$DIR/lib.sh"

clear

require_cmd curl
require_cmd grep

log "Lancement des tests depuis: $DIR"
ret

failed=0
count=0

for t in "$DIR"/*/[0-9][0-9]_test_*.sh; do
	[ -f "$t" ] || continue
	count=$((count + 1))
	log "→ RUN $(basename "$t")"
	if sh "$t"; then
		validate "← PASS $(basename "$t")"
		separator
	else
		failed=$((failed + 1))
		fail "← FAIL $(basename "$t")"
	fi
	ret
done

if [ "$count" -eq 0 ]; then
	warn "Aucun test trouvé."
	exit 0
fi

if [ "$failed" -eq 0 ]; then
	ok "Tous les tests sont OK ($count/$count)"
	exit 0
fi

if [ "$failed" -ne 0 ]; then
	fail "$failed test(s) ont échoué"
	exit 1
fi
