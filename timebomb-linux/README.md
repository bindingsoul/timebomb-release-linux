# Timebomb for Linux

## Overview
Timebomb is an open-source utility designed for Ubuntu/Linux (GNOME/Nautilus) that allows users to schedule automatic deletion of files and folders via a right-click menu. This tool is perfect for managing temporary files that clutter your system over time.

## Features
- Right-click delete timer for files and folders.
- Multiple time options: 1 Day, 7 Days, 1 Month, etc.
- JSON-based tracker for scheduled deletions.
- Manual cleaner script to remove expired files.
- Easy installation and uninstallation scripts.

## Folder Structure
```
timebomb-linux/
├── scripts/ # All right-click delete timer scripts
│ ├── dlt-5-min.sh
│ ├── dlt-1-day.sh
│ ├── dlt-7-day.sh
│ ├── dlt-1-month.sh
│ ├── dlt-6-month.sh
│ └── dlt-1-year.sh
├── cleaner.sh # Reads JSON, deletes expired files
├── install-timebomb.sh # One-click installer
├── uninstall-timebomb.sh # Clean removal
├── README.md # Documentation
└── LICENSE # MIT
```

## Installation
Run the following command to install Timebomb:
```bash
bash install-timebomb.sh
```

## Usage
1. Right-click on a file or folder.
2. Navigate to the "Scripts" menu.
3. Choose a delete timer option (e.g., "Delete in 7 Days").

## Uninstallation
Run the following command to uninstall Timebomb:
```bash
bash uninstall-timebomb.sh
```

## License
This project is licensed under the MIT License.
