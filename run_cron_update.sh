#!/bin/bash
# T_inf_0 Cron Execution Bridge
# Ensures the framework runs from its own directory and logs output.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit 1
python3 t_inf_0_framework.py >> cron_execution.log 2>&1
