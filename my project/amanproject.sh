#!/bin/bash

# Function to display top 10 applications consuming the most CPU and memory
top_apps() {
    echo "Top 10 Applications by CPU and Memory Usage:"
    ps aux --sort=-%cpu,-%mem | head -n 11
}

# Function to monitor network
network_monitor() {
    echo "Network Monitoring:"
    echo "Number of concurrent connections:"
    netstat -an | grep ESTABLISHED | wc -l
    echo "Packet drops:"
    netstat -s | grep "packet receive errors"
    echo "Network traffic (MB in and out):"
    ifconfig | grep 'RX bytes' | awk '{print $2, $6}'
}

# Function to display disk usage
disk_usage() {
    echo "Disk Usage:"
    df -h | awk '$5 > 80 {print $0}'
}

# Function to show system load
system_load() {
    echo "System Load:"
    uptime
    echo "CPU Usage Breakdown:"
    mpstat
}

# Function to display memory usage
memory_usage() {
    echo "Memory Usage:"
    free -h
}

# Function to monitor processes
process_monitor() {
    echo "Process Monitoring:"
    echo "Number of active processes:"
    ps aux | wc -l
    echo "Top 5 Processes by CPU and Memory Usage:"
    ps aux --sort=-%cpu,-%mem | head -n 6
}

# Function to monitor essential services
service_monitor() {
    echo "Service Monitoring:"
    for service in sshd nginx apache2 iptables; do
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
    done
}

# Main dashboard function
dashboard() {
    clear
    echo "System Monitoring Dashboard"
    echo "==========================="
    top_apps
    echo
    network_monitor
    echo
    disk_usage
    echo
    system_load
    echo
    memory_usage
    echo
    process_monitor
    echo
    service_monitor
}

# Command-line switches
while [[ "$1" != "" ]]; do
    case $1 in
        -cpu ) top_apps
               ;;
        -network ) network_monitor
                   ;;
        -disk ) disk_usage
                ;;
        -load ) system_load
                ;;
        -memory ) memory_usage
                  ;;
        -process ) process_monitor
                   ;;
        -service ) service_monitor
                   ;;
        * ) dashboard
            ;;
    esac
    shift
done

# Default to full dashboard if no switches are provided
if [ "$#" -eq 0 ]; then
    dashboard
fi



________________________________________________________________________________________________________________
Save the script to a file, e.g., monitor.sh.
Make the script executable: chmod +x monitor.sh.
Run the script with the desired switch, e.g., ./monitor.sh -cpu to view CPU usage.
