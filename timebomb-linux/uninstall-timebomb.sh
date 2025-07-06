#!/bin/bash
# uninstall-timebomb.sh: Removes Timebomb scripts and data

set -e

# Remove Nautilus scripts
NAUTILUS_SCRIPTS="$HOME/.local/share/nautilus/scripts"
for script in dlt-5-min.sh dlt-1-day.sh dlt-7-day.sh dlt-1-month.sh dlt-6-month.sh dlt-1-year.sh; do
  rm -f "$NAUTILUS_SCRIPTS/$script"
done

# Remove .timebomb directory
rm -rf "$HOME/.timebomb"

echo "🗑️ Timebomb uninstalled. Nautilus scripts and data removed."
