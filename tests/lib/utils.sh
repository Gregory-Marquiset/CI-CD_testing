
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

    ret; separator; ret; ret
    info "→ RUN $NAME"
    ret
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

    if [ "$L_SKIP" -ne 0 ]; then
        skiped "script skiped ($_dur_str)"
        ret; separator; ret; ret
        G_ERRNO=2
        return 2
    fi
    G_OK=$((G_OK + L_OK))
    G_KO=$((G_KO + L_KO))
    if [ "$L_KO" -eq 0 ]; then
        pass    "TOTAL: $L_COUNT  OK: $L_OK  KO: $L_KO  ($_dur_str)"
        ret; separator; ret; ret
        G_ERRNO=0
        return 0
    else
        fail      "TOTAL: $L_COUNT  OK: $L_OK  KO: $L_KO  ($_dur_str)"
        ret; separator; ret; ret
        G_ERRNO=1
        return 1
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

    ret; separator; ret

    if [ "$G_FAIL" -eq 0 ]; then
        validate    "TOTAL: $G_COUNT  PASS: $G_PASS  FAIL: $G_FAIL  SKIP: $G_SKIP  OK: $G_OK KO: $G_KO  ($_dur_str)"
    else
        failed      "TOTAL: $G_COUNT  PASS: $G_PASS  FAIL: $G_FAIL  SKIP: $G_SKIP  OK: $G_OK KO: $G_KO  ($_dur_str)"
    fi

    separator; ret; ret
}


skip() { L_SKIP=$((L_SKIP + 1)); }

require_cmd()
{
    command -v "$1" >/dev/null 2>&1 || fail "Commande manquante: $1"
}
