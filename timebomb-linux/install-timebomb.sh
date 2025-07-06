#!/bin/bash
# install-timebomb.sh: Installs Timebomb scripts and dependencies

set -e

# Ensure jq is installed
if ! command -v jq >/dev/null 2>&1; then
  echo "jq not found. Installing jq..."
  sudo apt-get update && sudo apt-get install -y jq
fi

# Create Nautilus scripts directory
NAUTILUS_SCRIPTS="$HOME/.local/share/nautilus/scripts"
mkdir -p "$NAUTILUS_SCRIPTS"

# Copy timer scripts
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)/scripts"
for script in "$SCRIPT_DIR"/dlt-*.sh; do
  cp "$script" "$NAUTILUS_SCRIPTS/"
  chmod +x "$NAUTILUS_SCRIPTS/$(basename "$script")"
done

# Copy cleaner.sh to ~/.timebomb for manual/cron use
mkdir -p "$HOME/.timebomb"
cp "$(cd "$(dirname "$0")" && pwd)/cleaner.sh" "$HOME/.timebomb/cleaner.sh"
chmod +x "$HOME/.timebomb/cleaner.sh"

# Install systemd service and timer (user mode)
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_USER_DIR"
cp "$(cd "$(dirname "$0")" && pwd)/timebomb-cleaner.service" "$SYSTEMD_USER_DIR/"
cp "$(cd "$(dirname "$0")" && pwd)/timebomb-cleaner.timer" "$SYSTEMD_USER_DIR/"

systemctl --user daemon-reload
systemctl --user enable --now timebomb-cleaner.timer

echo "✅ Timebomb installed! Right-click a file/folder → Scripts → pick a delete timer."
echo "🕑 Timebomb cleaner will now run every hour automatically."
