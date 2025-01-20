# Bash Scripting for System Administration

This repository contains four Bash scripts designed to automate common system management tasks:

1. Backup Script: Automates file backups using rsync.

2. Resource Monitoring Script: Monitors CPU, memory, and disk usage.

3. Log Rotation Script: Manages log files by rotating and cleaning them.

4. Network Configuration Script: Configures a static IP address on a network interface.

## Scripts Overview
#### 1. Backup Script (backup_script.sh):
This script automates file backups using rsync. It backs up files from a source directory to a remote directory on a remote host and logs the results.

Usage:
Set the required variables in the .env file or export them as environment variables:

```bash
SOURCE_DIR="/path/to/source"
LOG_FILE="/path/to/backup.log"
REMOTE_HOST="user@remotehost"
REMOTE_DIR="/path/to/remote/directory"
```
Run the script:
```bash
> chmod +x backup_script.sh
> ./backup_script.sh
```
Prerequisites:
* rsync must be installed on the local and remote machines.
* SSH access to the remote host.
------
#### 2. Resource Monitoring Script (monitoring.sh):
This script monitors CPU, memory, and disk usage and alerts if usage exceeds predefined thresholds.

Usage:
Set the thresholds in the script (or modify them as needed):

```bash
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
```
Run the script:
```bash
> chmod +x monitoring.sh
> ./monitoring.sh
```
Prerequisites:
* top, free, and df commands must be available (or alternatives like mpstat and /proc/meminfo).
-----
#### 3. Log Rotation Script (log_rotation.sh):
This script rotates and compresses log files that exceed a specified size and deletes old compressed logs.

Usage:
Set the configuration variables in the script:

```bash
LOG_DIR="/var/log/myapp"
MAX_LOG_SIZE=5000000  # 5MB
MAX_LOG_AGE=30        # 30 days
```
Run the script:
```bash
> chmod +x log_rotation.sh
> ./log_rotation.sh
```
Prerequisites:
* gzip and find commands must be available.
* Write permissions for the log directory.

-------

#### 4. Network Configuration Script (configure_network.sh):
This script configures a static IP address on a network interface using nmcli.

Usage:
1. Run the script and provide input when prompted:

```bash
> sudo ./configure_network.sh
```
2. Enter the network interface (e.g., eth0).

3. Enter the static IP address (e.g., 192.168.1.100).

4. Enter the gateway (e.g., 192.168.1.1).

5. Enter the DNS server (default: 8.8.8.8).

Prerequisites:
* nmcli (NetworkManager) must be installed.
* Root privileges are required.