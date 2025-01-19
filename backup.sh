#!/bin/bash

# Load env variables from .env file
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found."
    exit 1
fi

# Validate that all required variables are set
required_vars=("SOURCE_DIR" "LOG_FILE" "REMOTE_HOST" "REMOTE_DIR")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: $var is not set in .env file."
        exit 1
    fi
done

# Perform the backup
perform_backup(){
    rsync -avz "$SOURCE_DIR" "$REMOTE_HOST":"$REMOTE_DIR" > "$LOG_FILE" 2>&1
    if [$? -eq 0];
    then
        echo "Backup successful: $(date)" >> "$LOG_FILE"
    else
        echo "Backup failed: $(date)" >> "$LOG_FILE"
    fi
}

perform_backup