#!/bin/bash
# cleaner.sh: Deletes expired files/folders and updates tracker.json with robust error handling

set -euo pipefail

JSON_FILE="$HOME/.timebomb/tracker.json"
NOW=$(date +%s)
LOG_FILE="$HOME/.timebomb/cleaner.log"

# Dependency checks
if ! command -v jq >/dev/null 2>&1; then
  echo "[ERROR] jq is not installed. Please install jq." | tee -a "$LOG_FILE"
  exit 1
fi
if ! command -v notify-send >/dev/null 2>&1; then
  echo "[WARNING] notify-send is not installed. Notifications will be skipped." | tee -a "$LOG_FILE"
  NOTIFY=0
else
  NOTIFY=1
fi

mkdir -p "$HOME/.timebomb"
[ -f "$JSON_FILE" ] || echo '[]' > "$JSON_FILE"

# Read, delete expired, and keep unexpired, with notifications and error handling
DELETED_PATHS=()
FAILED_PATHS=()

for row in $(jq -c --argjson now "$NOW" '.[] | select(.delete_epoch <= $now)' "$JSON_FILE"); do
  path=$(echo "$row" | jq -r '.path')
  if [ -e "$path" ]; then
    if rm -rf -- "$path" 2>>"$LOG_FILE"; then
      DELETED_PATHS+=("$path")
      echo "[$(date)] Deleted: $path" >> "$LOG_FILE"
    else
      FAILED_PATHS+=("$path")
      echo "[$(date)] [ERROR] Failed to delete: $path" >> "$LOG_FILE"
    fi
  else
    # File/folder already gone, treat as deleted
    DELETED_PATHS+=("$path")
    echo "[$(date)] Already missing: $path" >> "$LOG_FILE"
  fi
done

# Keep only unexpired entries
NEW_JSON=$(jq --argjson now "$NOW" -c '[ .[] | select(.delete_epoch > $now) ]' "$JSON_FILE")
echo "$NEW_JSON" > "$JSON_FILE"

# Send notification if any files were deleted
if [ ${#DELETED_PATHS[@]} -gt 0 ] && [ "$NOTIFY" -eq 1 ]; then
  notify-send "Timebomb" "Deleted: ${DELETED_PATHS[*]}"
fi

# Notify about failures
if [ ${#FAILED_PATHS[@]} -gt 0 ] && [ "$NOTIFY" -eq 1 ]; then
  notify-send "Timebomb" "Failed to delete: ${FAILED_PATHS[*]} (see log)"
fi
