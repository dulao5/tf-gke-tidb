#!/bin/bash

set -m # Enable Job Control

# TiDB raw entrypoint
RAW_ENTRYPOINT="/usr/local/bin/tidb_start_script.sh"
if test ! -f $RAW_ENTRYPOINT ; then
  RAW_ENTRYPOINT="/tidb-server" # for local development
fi

# port
LIVENESS_PORT=4000  # TiDB port
READINESS_PORT=10088 # proxy port（use to Readiness）

# process PID var
SOCAT_PID=""
TIDB_PID=""

# graceful before wait time
if test -z "$GRACEFUL_BEFORE_WAIT_TIME" ; then
  export GRACEFUL_BEFORE_WAIT_TIME=15; 
fi

# graceful shutdown
function shutdown() {
	echo "$(date) Shutdown initiated..."

    # 1. close Readiness port proxy
    if [[ -n "$SOCAT_PID" ]]; then
        echo "$(date) Stopping readiness probe (PID: $SOCAT_PID)..."
        kill "$SOCAT_PID" || true
    fi

    # 2. wait GRACEFUL_BEFORE_WAIT_TIME seconds , drain connections
    echo "$(date) Waiting $GRACEFUL_BEFORE_WAIT_TIME seconds before stopping TIDB..."
    sleep $GRACEFUL_BEFORE_WAIT_TIME

    # 3. close TIDB
    if [[ -n "$TIDB_PID" ]]; then
        echo "$(date) Stopping TIDB (PID: $TIDB_PID)..."
        kill "$TIDB_PID"
        wait "$TIDB_PID"
    fi

    echo "$(date) Shutdown complete."
    exit 0
}

# process SIGTERM 和 SIGINT
trap shutdown SIGTERM SIGINT

# start Readiness proxy（10088 -> 3306）
function start_readiness_probe() {
    echo "$(date) Starting readiness probe on port $READINESS_PORT..."
    socat -x -v -d -d -lh -lu -ls -lpsocat TCP-LISTEN:$READINESS_PORT,fork,reuseaddr TCP:127.0.0.1:$LIVENESS_PORT &
    SOCAT_PID=$!
    echo "$(date) Readiness probe started with PID $SOCAT_PID"
}

# start TIDB
function start_tidb() {
    echo "$(date) Starting TIDB..."
    $RAW_ENTRYPOINT &
    TIDB_PID=$!
    echo "$(date) TIDB started with PID $TIDB_PID"
}

# start services
start_readiness_probe
start_tidb

# wait TIDB process
wait "$TIDB_PID"
