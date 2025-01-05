# Auto System Backup Tool

## Overview
This automated backup system creates timestamped backups of critical system directories and automatically commits them to a Git repository. The script is designed to run on system startup through a systemd service.

## What it Does
The script performs the following operations:
1. Creates a new directory named with the current timestamp
2. Backs up the following system directories:
   - `/var/lock`: Contains lock files used by applications
   - `/var/run`: Contains runtime data for system services
   - `/var/backups`: Contains system backup files
3. Automatically commits the changes to Git
4. Pushes the changes to a remote repository

## Script Breakdown
```bash
#!/usr/bin/bash

# Create timestamp with underscores instead of spaces and colons
x="$(date | tr ' :,' '_')"

# Create a new directory with the timestamp name
mkdir -p "$x"

# Copy system directories to the backup location
cp -r /var/lock "/home/micro/Desktop/Repos-Git/Auto/$x"
cp -r /var/run "/home/micro/Desktop/Repos-Git/Auto/$x"
cp -r /var/backups "/home/micro/Desktop/Repos-Git/Auto/$x"

# Add all changes to Git
git add .

# Commit changes with timestamp as message
git commit -m "$x"

# Push to remote repository
git push
```

## Installation

### Prerequisites
- Git must be installed and configured
- A remote Git repository must be set up and authenticated
- System must use systemd (most modern Linux distributions)

### Setting up the Service
1. Create a systemd service file:
```bash
sudo nano /etc/systemd/system/auto-script.service
```

2. Add the following content:
```ini
[Unit]
Description=Auto Script Service
After=network.target
Wants=network-online.target
After=multi-user.target

[Service]
Type=simple
ExecStart=/home/micro/Desktop/Repos-Git/Auto/main.sh
User=micro
WorkingDirectory=/home/micro/Desktop/Repos-Git/Auto
Restart=on-failure
RestartSec=5
StartLimitIntervalSec=0

[Install]
WantedBy=multi-user.target
```

3. Make the script executable:
```bash
chmod +x /home/micro/Desktop/Repos-Git/Auto/main.sh
```

4. Enable and start the service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable auto-script
sudo systemctl start auto-script
```

## Maintenance

### Checking Service Status
```bash
sudo systemctl status auto-script
```

### Viewing Logs
```bash
journalctl -u auto-script
```

### Manual Execution
```bash
cd ~/Desktop/Repos-Git/Auto
./main.sh
```

## Important Notes
- Ensure sufficient disk space is available for backups
- The script requires appropriate permissions to read from `/var` directories
- Git credentials must be properly configured for automatic pushing
- Consider implementing log rotation or cleanup for older backups
- The backup directories might contain sensitive system information

## Troubleshooting
1. If the service fails to start, check the logs:
```bash
journalctl -u auto-script -n 50 --no-pager
```

2. If Git push fails:
- Verify network connectivity
- Check Git credentials
- Ensure remote repository is accessible

## Security Considerations
- The backup contains system-sensitive information
- Ensure the remote repository is secure
- Consider implementing encryption for sensitive data
- Review file permissions regularly

## Author
Geoffrey Ashimwe
