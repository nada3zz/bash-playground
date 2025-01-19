#!/bin/bash

LOG_DIR="/var/log/myapp"
MAX_LOG_SIZE=5000000 # 5MB
MAX_LOG_AGE=30 # 30 Days

# Check if log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Log directory $LOG_DIR does not exist."
    exit 1
fi

# Function to rotate logs
rotate_logs() {
    local rotated=0
    for log_file in "$LOG_DIR"/*.log; do
        if [ -f "$log_file" ] && [ $(stat -c%s "$log_file") -gt $MAX_LOG_SIZE ]; then
            new_file="$log_file.$(date +'%Y%m%d')"
            mv "$log_file" "$new_file"
            gzip "$new_file"
            echo "Log rotated: $log_file -> $new_file.gz"
            rotated=1
        fi
    done
    if [ "$rotated" -eq 0 ]; then
        echo "No logs to rotate."
    fi
}

# Function to clean up old logs
clean_old_logs() {
    local deleted=$(find "$LOG_DIR" -name "*.gz" -mtime +$MAX_LOG_AGE -print -exec rm {} \; | wc -l)
    if [ "$deleted" -gt 0 ]; then
        echo "Old logs cleaned up: $deleted files deleted."
    else
        echo "No old logs to clean."
    fi
}


rotate_logs
clean_old_logs