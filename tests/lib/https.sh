
# =========
# HTTPS
# =========

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
