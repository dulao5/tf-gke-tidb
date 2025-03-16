#!/bin/bash

set -e

# MySQL raw entrypoint
MYSQL_ENTRYPOINT="/docker-entrypoint.sh"

# port
LIVENESS_PORT=3306  # MySQL port
READINESS_PORT=10088 # proxy port（use to Readiness）

# process PID var
SOCAT_PID=""
MYSQL_PID=""

# graceful shutdown
function shutdown() {
    echo "Shutdown initiated..."

    # 1. close Readiness port proxy
    if [[ -n "$SOCAT_PID" ]]; then
        echo "Stopping readiness probe (PID: $SOCAT_PID)..."
        kill "$SOCAT_PID" || true
    fi

    # 2. wait 90 s , drain connections
    echo "Waiting 90 seconds before stopping MySQL..."
    sleep 90

    # 3. close MySQL
    if [[ -n "$MYSQL_PID" ]]; then
        echo "Stopping MySQL (PID: $MYSQL_PID)..."
        kill "$MYSQL_PID"
        wait "$MYSQL_PID"
    fi

    echo "Shutdown complete."
    exit 0
}

# process SIGTERM 和 SIGINT
trap shutdown SIGTERM SIGINT

# start Readiness proxy（10088 -> 3306）
function start_readiness_probe() {
    echo "Starting readiness probe on port $READINESS_PORT..."
    socat TCP-LISTEN:$READINESS_PORT,fork,reuseaddr TCP:127.0.0.1:$LIVENESS_PORT &
    SOCAT_PID=$!
    echo "Readiness probe started with PID $SOCAT_PID"
}

# start MySQL
function start_mysql() {
    echo "Starting MySQL..."
    $MYSQL_ENTRYPOINT mysqld &
    MYSQL_PID=$!
    echo "MySQL started with PID $MYSQL_PID"
}

# start services
start_readiness_probe
start_mysql

# wait MySQL process
wait "$MYSQL_PID"
