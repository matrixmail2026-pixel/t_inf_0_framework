#!/bin/bash
# T_inf_0 Daemon Stopper
# Gracefully stops a running background scheduler instance.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$SCRIPT_DIR/scheduler.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "[Error] No scheduler.pid found. Is the daemon running?"
    exit 1
fi

PID=$(cat "$PID_FILE")
echo "[Daemon] Stopping scheduler with PID $PID..."

if kill -TERM "$PID" 2>/dev/null; then
    echo "[Daemon] Graceful shutdown signal sent."
    sleep 2
    if kill -0 "$PID" 2>/dev/null; then
        echo "[Daemon] Process still running. Forcing kill..."
        kill -9 "$PID"
    fi
    rm -f "$PID_FILE"
    echo "[Daemon] Scheduler stopped."
else
    echo "[Error] Failed to send signal to PID $PID."
    exit 1
fi
