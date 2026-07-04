#!/usr/bin/env bash
set -uo pipefail

WORKSPACE_DIR="/workspace"
LOG_DIR="$WORKSPACE_DIR/.devcontainer/logs"
mkdir -p "$LOG_DIR"

start_if_needed () {
  local name="$1" port="$2" dir="$3" cmd="$4"
  if lsof -i ":$port" -sTCP:LISTEN >/dev/null 2>&1; then
    echo "==> $name already listening on :$port, skipping."
    return
  fi
  echo "==> Starting $name ($cmd) in $dir — logs: $LOG_DIR/$name.log"
  (cd "$dir" && nohup bash -c "$cmd" > "$LOG_DIR/$name.log" 2>&1 &)
}

start_if_needed "api"   3000 "$WORKSPACE_DIR/api"         "npm run start:dev"
start_if_needed "front" 4200 "$WORKSPACE_DIR/front-pharma" "npm start -- --host 0.0.0.0"
