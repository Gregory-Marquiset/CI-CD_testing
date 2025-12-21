#!/bin/sh

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$DIR/../lib.sh"
HTTPS="https://www.google.com/"

test $G_SKIP
local_init


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

local_resume