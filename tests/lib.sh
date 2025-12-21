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
    ON="$(printf '\033[')"
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
# Logging and text edition
# =========

ret()       { printf "\n"; }
separator() { printf "${ON}${BLU}m""           ------------------------------""$RES"; }

test()      { printf "%s" " [${ON}${MAG};${BLINK}m" "   TEST   " "${RES}] " "$*"; ret; }
log()       { printf "%s" " [${ON}${BLU}m"          "   INFO   " "${RES}] " "$*"; ret; }
warn()      { printf "%s" " [${ON}${YEL}m"          "   WARN   " "${RES}] " "$*"; ret; }

ok()        { printf "%s" " [${ON}${CYA}m"          "    OK    " "${RES}] " "$*"; ret; }
pass()      { printf "%s" " [${ON}${GRE}m"          "   PASS   " "${RES}] " "$*"; ret; }
validate()  { printf "%s" " [${ON}${GRE};${BLINK}m" " VALIDATE " "${RES}] " "$*"; ret; }

ko()        { printf "%s" " [${ON}${BRO}m"          "    KO    " "${RES}] " "$*"; ret; }
fail()      { printf "%s" " [${ON}${RED}m"          "   FAIL   " "${RES}] " "$*"; ret; }
failed()    { printf "%s" " [${ON}${RED};${BLINK}m" "  FAILED  " "${RES}] " "$*"; ret; }

red()   { printf "%s" "${ON}${RED}m" "$*" "$RES"; }
gre()   { printf "%s" "${ON}${GRE}m" "$*" "$RES"; }
yel()   { printf "%s" "${ON}${YEL}m" "$*" "$RES"; }
blu()   { printf "%s" "${ON}${BLU}m" "$*" "$RES"; }
mag()   { printf "%s" "${ON}${MAG}m" "$*" "$RES"; }
cia()   { printf "%s" "${ON}${CYA}m" "$*" "$RES"; }
bro()   { printf "%s" "${ON}${BRO}m" "$*" "$RES"; }
bla()   { printf "%s" "${ON}${BLA}m" "$*" "$RES"; }

# =========
# Utils
# =========

_now_ms() { date +%s%3N; }

global_init()
{
    G_EPOCH="$(_now_ms)"
    G_COUNT=0
    G_OK=0
    G_PASS=0
    G_KO=0
    G_FAIL=0
    G_SKIP=0
    G_ERRNO=0
}

# Avant de commencer votre logique ajouter: TL_var_init
local_init()
{
    L_EPOCH="$(_now_ms)"
    L_COUNT=0
    L_OK=0
    L_KO=0
    L_SKIP=0
    L_ERRNO=0
}

# Apres votre logique ajouter: local_resume
local_resume()
{
    _end_ms="$(_now_ms)"
    _start_ms="${L_EPOCH:-$_end_ms}"
    _dur_ms=$((_end_ms - _start_ms))

    _min=$((_dur_ms / 60000))
    _sec=$(((_dur_ms / 1000) % 60))
    _ms=$((_dur_ms % 1000))

    if [ "$_min" -gt 0 ]; then
        _dur_str="${_min}m${_sec}s${_ms}ms"
    elif [ "$_sec" -gt 0 ]; then
        _dur_str="${_sec}s${_ms}ms"
    else
        _dur_str="${_ms}ms"
    fi

    G_OK=$((G_OK + L_OK))
    G_KO=$((G_KO + L_KO))
	G_SKIP=$((G_SKIP + 1))
    if [ "$L_KO" -eq 0 ]; then
        pass    "TOTAL: $L_COUNT  OK: $L_OK  KO: $L_KO  SKIP: $L_SKIP  ($_dur_str)"
        G_ERRNO=0
        exit 0
    else
        fail      "TOTAL: $L_COUNT  OK: $L_OK  KO: $L_KO  SKIP: $L_SKIP  ($_dur_str)"
        G_ERRNO=1
        exit 1
    fi
}

global_resume()
{
    _end_ms="$(_now_ms)"
    _start_ms="${G_EPOCH:-$_end_ms}"
    _dur_ms=$((_end_ms - _start_ms))

    _min=$((_dur_ms / 60000))
    _sec=$(((_dur_ms / 1000) % 60))
    _ms=$((_dur_ms % 1000))

    if [ "$_min" -gt 0 ]; then
        _dur_str="${_min}m${_sec}s${_ms}ms"
    elif [ "$_sec" -gt 0 ]; then
        _dur_str="${_sec}s${_ms}ms"
    else
        _dur_str="${_ms}ms"
    fi

    ret
    separator
    ret
    if [ "$G_FAIL" -eq 0 ]; then
        validate    "TOTAL: $G_COUNT  PASS: $G_PASS  FAIL: $G_FAIL  SKIP: $G_SKIP  OK: $G_OK KO: $G_KO  ($_dur_str)"
    else
        failed      "TOTAL: $G_COUNT  PASS: $G_PASS  FAIL: $G_FAIL  SKIP: $G_SKIP  OK: $G_OK KO: $G_KO  ($_dur_str)"
    fi
    separator
}


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
    L_COUNT=$((L_COUNT + 1))
    _url="$1"
    _max="${2:-30}"
    _pause="${3:-1}"

    _i=1
    while [ "$_i" -le "$_max" ]; do
        if curl -fsS "$_url" >/dev/null 2>&1; then
            ok "HTTPS up: $_url"
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            return 0
        fi
        warn "Attente HTTPS: $_url (${_i}/${_max})"
        _i=$((_i + 1))
        sleep "$_pause"
    done
    ko "Timeout: $_url ne répond pas"
    L_KO=$((L_KO + 1))
    L_ERRNO=1
    return 1
}

# http_get_body URL -> GET le body
# http_get_body v URL -> + imprime le body
https_get_body()
{
    L_COUNT=$((L_COUNT + 1))
    if [ "$#" -ne 2 ]; then
        _body="$1"
    else
        _body="$2"
    fi

    if [ "$1" = "v" ]; then
        if curl -fsS "$_body"; then
            ok "GET body successful: $_body"
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            return 0
        else
            ko "GET body failed: $_body"
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            return 1
        fi
    else
        if curl -fsS "$_body" >/dev/null; then
            ok "GET body successful: $_body"
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            return 0
        else
            ko "GET body failed: $_body"
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            return 1
        fi
    fi
}

# http_get_headers URL -> GET le header
# http_get_headers v URL -> + imprime le header
https_get_headers()
{
    L_COUNT=$((L_COUNT + 1))
    if [ "$#" -ne 2 ]; then
        _head="$1"
    else
        _head="$2"
    fi

    if [ "$1" = "v" ]; then
        if curl -fIsS "$_head"; then
            ok "headers GET successful: $_head"
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            return 0
        else
            ko "headers GET failed: $_head"
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            return 1
        fi
    else
        if curl -fIsS "$_head" >/dev/null; then
            ok "headers GET successful: $_head"
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            return 0
        else
            ko "headers GET failed: $_head"
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            return 1
        fi
    fi
}

# https_get_health URL -> GET le health check
# https_get_health v URL -> + imprime le health check
https_get_health()
{
    L_COUNT=$((L_COUNT + 1))
    if [ "$#" -ge 2 ]; then
        _health="$2"health/
    else
        _health="$1"health/
    fi

    if [ "$1" = "v" ]; then
        if curl -fsS "$_health"; then
            ok "health check successful: $_health"
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            return 0
        else
            ko "health check failed: $_health"
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            return 1
        fi
    else
        if curl -fsS "$_health" >/dev/null; then
            ok "health check successful: $_health"
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            return 0
        else
            ko "health check failed: $_health"
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            return 1
        fi
    fi
}

# assert_contains "haystack" "needle" "label"
assert_contains()
{
    L_COUNT=$((L_COUNT + 1))
    _hay="$1"
    _needle="$2"
    _label="${3:-_contenu}"
    echo "$_hay" | grep -qF "$_needle" || fail "Assert failed: '$_label' ne contient pas '$_needle'"
    ok "Assert ok: $_label contient '$_needle'"
    L_OK=$((L_OK + 1))
    L_ERRNO=0
    return 0
}
