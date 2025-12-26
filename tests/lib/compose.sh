
# =========
# Compose
# =========

# v -> imprime la reponse

COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

# creer la cmd compose
compose() { docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" "$@"; }

# compose_config [v]
compose_config()
{
    L_COUNT=$((L_COUNT + 1))
    logs compose config test

    if [ "$1" = "v" ]; then
        if compose config; then
            ok compose config valide
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        else
            ko compose config invalide
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi
    else
        if compose config > /dev/null; then
            ok compose config valide
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        else
            ko compose config invalide
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi
    fi
}

# compose_build [v]
compose_build()
{
    L_COUNT=$((L_COUNT + 1))
    logs compose build test

    if [ "$1" = "v" ]; then
        if compose build --no-cache; then
            ok compose build valide
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        else
            ko compose build invalide
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi
    else
        if compose build --no-cache > /dev/null; then
            ok compose build valide
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        else
            ko compose build invalide
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi
    fi
}

# compose_up [v]
compose_up()
{
    L_COUNT=$((L_COUNT + 1))
    logs compose up test

    if [ "$1" = "v" ]; then
        if compose up -d --build --remove-orphans; then
            ok compose up valide
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        else
            ko compose up invalide
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi
    else
        if compose up -d --build --remove-orphans > /dev/null; then
            ok compose up valide
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        else
            ko compose up invalide
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi
    fi
}

# compose_down [v]
compose_down()
{
    L_COUNT=$((L_COUNT + 1))
    logs compose down test

    if [ "$1" = "v" ]; then
        if compose down -v --remove-orphans; then
            ok compose down valide
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        else
            ko compose down invalide
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi
    else
        if compose down -v --remove-orphans > /dev/null; then
            ok compose down valide
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        else
            ko compose down invalide
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi
    fi
}

# retourne le container id d'un service
compose_cid() { compose ps -q "$1"; }

# retourne le health status
compose_health_status()
{
    svc="$1"

    cid="$(compose_cid "$svc")"
    ret
    test $cid
    ret
    if [ -z "$cid" ]; then
        return 1
    fi

    status="$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}' "$cid" 2>/dev/null || true)"
    if [ -z "$status" ]; then
        return 1
    fi

    return 0
}


# compose_wait_healthy [v] <service> [timeout]
compose_wait_healthy()
{
    L_COUNT=$((L_COUNT + 1))
    logs compose wait_healthy "$svc"

    if [ "$1" = "v" ]; then
        verbose="$1"
        svc="$2"
        _timeout="${3:-60}"
    else
        verbose=""
        svc="$1"
        _timeout="${2:-60}"
    fi

    _i=0
    while [ "$_i" -lt "$_timeout" ]; do
        status="$(compose_health_status "$svc")"

        if [ "$status" = "healthy" ]; then
            ok "$svc" healthy "(${_i}s)"
            L_OK=$((L_OK + 1))
            L_ERRNO=0
            ret
            return 0
        fi

        if [ "$status" = "no-container" ]; then
            ko "$svc" no-container
            [ "$verbose" = "v" ] && compose ps || true
            L_KO=$((L_KO + 1))
            L_ERRNO=1
            ret
            return 1
        fi

        cid="$(compose_cid "$svc")"
        if [ -n "$cid" ]; then
            running="$(docker inspect -f '{{.State.Running}}' "$cid" 2>/dev/null || echo "false")"
            if [ "$running" != "true" ]; then
                ko "$svc" "not-running (status=$status)"
                [ "$verbose" = "v" ] && docker inspect "$cid" || true
                L_KO=$((L_KO + 1))
                L_ERRNO=1
                ret
                return 1
            fi
        fi

        warn "[$svc] health=$status (t=${_i}s/${timeout}s)"
        _i=$((_i + 1))
        sleep 1
    done

    ko "$svc" "timeout waiting healthy (last=$status, ${timeout}s)"
    [ "$verbose" = "v" ] && compose logs --tail=80 "$svc" || true
    L_KO=$((L_KO + 1))
    L_ERRNO=1
    ret
    return 1
}
