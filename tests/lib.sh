#!/bin/sh

# =========
# Colors, styles et backgrounds (désactivables via NO_ANSI=1)
# =========
if [ "${NO_ANSI:-0}" = "1" ] || [ ! -t 1 ]; then
    RES=""
    BOLD="";        DIM=""
    ITALIC="";      UNDER=""
    BLINK="";       STRIKE=""
    RED="";         GRE=""
    YEL="";         BLU=""
    MAG="";         CYA=""
    BRO="";         BLA=""
    BG_BLACK="";    BG_GRAY=""
    BG_WHITE="";    BG_RED=""
    BG_GREEN="";    BG_BROWN=""
    BG_BLUE="";     BG_MAGENTA=""
    BG_CYAN="";     BG_YELLOW=""
else
    RES="$(printf '\033[0m')"

    BOLD="1";       DIM="2"
    ITALIC="3";     UNDER="4"
    BLINK="5";      STRIKE="9"

    RED="31";       GRE="92"
    YEL="93";       BLU="94"
    MAG="95";       CYA="96"
    BRO="33";       BLA="30"

    BG_BLACK="40";  BG_GRAY="100"
    BG_WHITE="107"; BG_RED="41"
    BG_GREEN="42";  BG_BROWN="43"
    BG_BLUE="44";   BG_MAGENTA="45"
    BG_CYAN="46";   BG_YELLOW="103"
fi

# =========
# Logging
# =========
_ts() { date +"%Y-%m-%d %H:%M:%S"; }

ret()     { printf "\n";}

log()
{
    printf "%s" "$(_ts) [" "$(printf "\033["$BLU"m")" "   INFO   " "$RES" "] " "$*"
    ret
}
warn()
{
    printf "%s" "$(_ts) [" "$(printf "\033["$YEL"m")" "   WARN   " "$RES" "] " "$*"
    ret
}
ok()
{
    printf "%s" "$(_ts) [" "$(printf "\033["$GRE"m")" "    OK    " "$RES" "] " "$*"
    ret
}
validate()
{
    printf "%s" "$(_ts) [" "$(printf "\033["$GRE"m")" " VALIDATE " "$RES" "] " "$*"
    ret
}
failed()
{
    printf "%s" "$(_ts) [" "$(printf "\033["$RED"m")" "  FAILED  " "$RES" "] " "$*"
    ret
}
test()
{
    printf "%s" "$(_ts) [" "$(printf "\033["$CYA";"$BLINK"m")" "   TEST   " "$RES" "] " "$*"
    ret
}
separator()
{
    ret
    printf "\033["$BLU"m""           ------------------------------""$RES"
    ret
}

red()   { printf "%s" "$(printf "\033["$RED"m")" "$*" "$RES"; }
gre()   { printf "%s" "$(printf "\033["$GRE"m")" "$*" "$RES"; }
yel()   { printf "%s" "$(printf "\033["$YEL"m")" "$*" "$RES"; }
blu()   { printf "%s" "$(printf "\033["$BLU"m")" "$*" "$RES"; }
mag()   { printf "%s" "$(printf "\033["$MAG"m")" "$*" "$RES"; }
cia()   { printf "%s" "$(printf "\033["$CYA"m")" "$*" "$RES"; }
bro()   { printf "%s" "$(printf "\033["$BRO"m")" "$*" "$RES"; }
bla()   { printf "%s" "$(printf "\033["$BLA"m")" "$*" "$RES"; }

# =========
# Helpers
# =========require_cmd(curl)
require_cmd()
{
    command -v "$1" >/dev/null 2>&1 || fail "Commande manquante: $1"
}

# wait_https URL [max_tries] [sleep_sec]
wait_https()
{
    url="$1"
    max="${2:-30}"
    pause="${3:-1}"

    i=1
    while [ "$i" -le "$max" ]; do
        if curl -fsS "$url" >/dev/null 2>&1; then
            ok "HTTPS up: $url"
            return 0
        fi
        log "Attente HTTPS: $url (${i}/${max})"
        i=$((i + 1))
        sleep "$pause"
    done
    failed "Timeout: $url ne répond pas"
    return 1
}

# http_get_body URL -> GET le body
# http_get_body v URL -> + imprime le body
https_get_body()
{
    if [ "$#" -ne 2 ]; then
        BODY="$1"
    else
        BODY="$2"
    fi

    if [ "$1" = "v" ]; then
        if curl -fsS "$BODY"; then
            ok "GET body successful: $BODY"
        else
            failed "GET body failed: $BODY"
        fi
    else
        if curl -fsS "$BODY" >/dev/null; then
            ok "GET body successful: $BODY"
        else
            failed "GET body failed: $BODY"
        fi
    fi
}

# http_get_headers URL -> GET le header
# http_get_headers v URL -> + imprime le header
https_get_headers()
{
    if [ "$#" -ne 2 ]; then
        HEAD="$1"
    else
        HEAD="$2"
    fi

    if [ "$1" = "v" ]; then
        if curl -fIsS "$HEAD"; then
            ok "headers GET successful: $HEAD"
        else
            failed "headers GET failed: $HEAD"
        fi
    else
        if curl -fIsS "$HEAD" >/dev/null; then
            ok "headers GET successful: $HEAD"
        else
            failed "headers GET failed: $HEAD"
        fi
    fi
}

# https_get_health URL -> GET le health check
# https_get_health v URL -> + imprime le health check
https_get_health()
{
    if [ "$#" -ge 2 ]; then
        HEALTH="$2"health/
    else
        HEALTH="$1"health/
    fi

    if [ "$1" = "v" ]; then
        if curl -fsS "$HEALTH"; then
            ok "health check successful: $HEALTH"
        else
            failed "health check failed: $HEALTH"
        fi
    else
        if curl -fsS "$HEALTH" >/dev/null; then
            ok "health check successful: $HEALTH"
        else
            failed "health check failed: $HEALTH"
        fi
    fi
}

# assert_contains "haystack" "needle" "label"
assert_contains()
{
    hay="$1"
    needle="$2"
    label="${3:-contenu}"
    echo "$hay" | grep -qF "$needle" || failed "Assert failed: '$label' ne contient pas '$needle'"
    ok "Assert OK: $label contient '$needle'"
}
