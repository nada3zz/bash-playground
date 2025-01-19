#!/bin/bash

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80


# Function to check CPU usage
check_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); 
    then
        printf "High CPU usage: %.2f%%\n" "$cpu_usage"
    fi
}

# Function to check memory usage
check_memory_usage() {
    if command -v free &> /dev/null; then
        mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    else
        mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        mem_usage=$((100 - (mem_available * 100 / mem_total)))
    fi

    if (( ${mem_usage%.*} > $MEM_THRESHOLD )); then
        printf "High Memory usage: %.2f%%\n" "$mem_usage"
    fi
}

# Function to check disk usage
check_disk_usage() {
    disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; 
    then
        echo "High Disk usage: $disk_usage%"
    fi
}


#Run the checks
check_cpu_usage
check_memory_usage
check_disk_usage