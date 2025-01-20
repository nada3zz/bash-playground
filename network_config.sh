#!/bin/bash

# Function to validate IP address format
validate_ip() {
    local ip="$1"
    if [[ $ip =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to validate CIDR
validate_cidr() {
    local cidr="$1"
    if [[ $cidr =~ ^[0-9]{1,2}$ ]] && [ "$cidr" -ge 0 ] && [ "$cidr" -le 32 ]; then
        return 0
    else
        return 1
    fi
}

# Function to configure static IP
configure_static_ip() {
    echo "Configuring static IP for interface $INTERFACE..."

    # Check if the interface exists
    if ! ip link show "$INTERFACE" &> /dev/null; then
        echo "Error: Interface $INTERFACE does not exist."
        exit 1
    fi

    # Check if a connection profile already exists
    if nmcli con show | grep -w "$INTERFACE" &> /dev/null; then
        echo "Modifying existing connection profile for $INTERFACE..."
        sudo nmcli con mod "$INTERFACE" ipv4.addresses "$STATIC_IP/$CIDR"
        sudo nmcli con mod "$INTERFACE" ipv4.gateway "$GATEWAY"
        sudo nmcli con mod "$INTERFACE" ipv4.dns "$DNS1"
        sudo nmcli con mod "$INTERFACE" ipv4.method manual
    else
        echo "Creating new connection profile for $INTERFACE..."
        sudo nmcli con add type ethernet autoconnect yes con-name "$INTERFACE" ifname "$INTERFACE"
        sudo nmcli con mod "$INTERFACE" ipv4.addresses "$STATIC_IP/$CIDR"
        sudo nmcli con mod "$INTERFACE" ipv4.gateway "$GATEWAY"
        sudo nmcli con mod "$INTERFACE" ipv4.dns "$DNS1"
        sudo nmcli con mod "$INTERFACE" ipv4.method manual
    fi

    echo "Static IP configuration done."
}

# Function to restart the network service
restart_network() {
    echo "Restarting network service for $INTERFACE..."
    sudo nmcli con up "$INTERFACE"
    echo "Network service restarted."
}

# Function to display current network configuration
show_network_config() {
    echo "Current network configuration for $INTERFACE:"
    ip addr show "$INTERFACE"
}

# Function to automate the whole process
automate_network_config() {
    configure_static_ip
    restart_network
    show_network_config
}

# Main script execution
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

# Prompt for user input
read -p "Enter the network interface (e.g., eth0): " INTERFACE
read -p "Enter the static IP address (e.g., 192.168.1.100): " STATIC_IP
read -p "Enter the gateway (e.g., 192.168.1.1): " GATEWAY
read -p "Enter the DNS server (default: 8.8.8.8): " DNS1
DNS1=${DNS1:-8.8.8.8} # Use default if no input provided

# Validate inputs
if ! validate_ip "$STATIC_IP"; then
    echo "Error: Invalid static IP address."
    exit 1
fi

if ! validate_ip "$GATEWAY"; then
    echo "Error: Invalid gateway IP address."
    exit 1
fi

if ! validate_cidr "$CIDR"; then
    echo "Error: Invalid CIDR."
    exit 1
fi

# Run the automation
automate_network_config