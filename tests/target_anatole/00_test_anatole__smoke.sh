#!/bin/sh
set -eu

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$DIR/../lib.sh"
HTTPS="https://www.google.com/"

log wait https test
wait_https $HTTPS
ret

log https health test
https_get_health $HTTPS
ret

log https headers test
https_get_headers $HTTPS
ret

log https body test
https_get_body $HTTPS
ret

test test
