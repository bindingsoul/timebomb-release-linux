#!/bin/bash
# dlt-6-month.sh: Schedule files/folders for deletion in 6 months with error handling

set -euo pipefail

DELETE_EPOCH=$(date -d "+6 months" +%s)
JSON_FILE="$HOME/.timebomb/tracker.json"
LOG_FILE="$HOME/.timebomb/timer.log"

# Dependency check
if ! command -v jq >/dev/null 2>&1; then
  echo "[ERROR] jq is not installed. Please install jq." | tee -a "$LOG_FILE"
  exit 1
fi

mkdir -p "$HOME/.timebomb"
[ -f "$JSON_FILE" ] || echo '[]' > "$JSON_FILE"

for f in "$@"; do
  if [ ! -e "$f" ]; then
    echo "[$(date)] [ERROR] File/folder not found: $f" | tee -a "$LOG_FILE"
    continue
  fi
  if jq --arg f "$f" --argjson e "$DELETE_EPOCH" \
    'if . == [] then [{"path": $f, "delete_epoch": $e}] else . + [{"path": $f, "delete_epoch": $e}] end' \
    "$JSON_FILE" 2>/dev/null > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"; then
    echo "[$(date)] Scheduled for deletion: $f (in 6 months)" | tee -a "$LOG_FILE"
    echo "💣 Scheduled for deletion: $f (in 6 months)"
  else
    echo "[$(date)] [ERROR] Failed to schedule: $f" | tee -a "$LOG_FILE"
  fi
done
