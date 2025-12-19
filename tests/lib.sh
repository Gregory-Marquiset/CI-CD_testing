#!/bin/sh

# =========
# Colors (désactivables via NO_COLOR=1)
# =========
if [ "${NO_COLOR:-0}" = "1" ] || [ ! -t 1 ]; then
    C_RESET=""; C_RED=""; C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_DIM=""
else
    C_RESET="$(printf '\033[0m')"
    C_RED="$(printf '\033[31m')"
    C_GREEN="$(printf '\033[32m')"
    C_YELLOW="$(printf '\033[33m')"
    C_BLUE="$(printf '\033[34m')"
    C_DIM="$(printf '\033[2m')"
fi

# =========
# Logging
# =========
_ts() { date +"%Y-%m-%d %H:%M:%S"; }

log()   { printf "%s %s[%s]%s %s\n" "$(_ts)" "$C_BLUE" "INFO" "$C_RESET" "$*"; }
warn()  { printf "%s %s[%s]%s %s\n" "$(_ts)" "$C_YELLOW" "WARN" "$C_RESET" "$*"; }
ok()    { printf "%s %s[%s]%s %s\n" "$(_ts)" "$C_GREEN" " OK " "$C_RESET" "$*"; }
fail()  { printf "%s %s[%s]%s %s\n" "$(_ts)" "$C_RED" "FAIL" "$C_RESET" "$*"; exit 1; }

# =========
# Helpers
# =========require_cmd(curl)
require_cmd() {
    command -v "$1" >/dev/null 2>&1 || fail "Commande manquante: $1"
}

# wait_http URL [max_tries] [sleep_sec]
wait_http() {
    url="$1"
    max="${2:-30}"
    pause="${3:-1}"

    i=1
    while [ "$i" -le "$max" ]; do
        if curl -fsS "$url" >/dev/null 2>&1; then
            ok "HTTP up: $url"
            return 0
        fi
        log "Attente HTTP: $url (${i}/${max})"
        i=$((i + 1))
        sleep "$pause"
    done
    fail "Timeout: $url ne répond pas"
}

# http_get URL -> imprime le body
http_get() {
    curl -fsS "$1" || fail "GET failed: $1"
}

# assert_contains "haystack" "needle" "label"
assert_contains() {
    hay="$1"
    needle="$2"
    label="${3:-contenu}"
    echo "$hay" | grep -qF "$needle" || fail "Assert failed: '$label' ne contient pas '$needle'"
    ok "Assert OK: $label contient '$needle'"
}
