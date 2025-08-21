#!/bin/bash

echo
echo "############################"
echo "Basic Performance State"
echo "############################"
echo


# CPU Usage
get_cpu_usage() {
    cpu_idle=$(top -bn1 | awk -F',' '/Cpu/ {print $4}' | awk '{print $1}')
    cpu_load=$(echo "100 - $cpu_idle" | bc)
    printf "CPU Load: %.1f%%\n" "$cpu_load"
}

# Memory Usage
get_memory_usage() {
    read total used <<< $(free -m | awk 'NR==2 {print $2, $3}')
    percent=$(awk "BEGIN {printf \"%.2f\", ($used/$total)*100}")
    echo "Used Memory: ${used}MiB / ${total}MiB | Memory Usage: $percent%"
}

# Disk Usage (root)
get_disk_usage() {
    df -h / | awk 'NR==2 {print "Used Disk: "$3" / "$2" | Disk Usage: "$5}'
}

# Top 5 processes by CPU
get_cpu_top() {
    echo "=== Top 5 processes by CPU usage ==="
    ps aux --sort=-%cpu | awk 'NR==1 || NR<=6' | column -t
    echo
}

# Top 5 processes by Memory
get_mem_top() {
    echo "=== Top 5 processes by Memory usage ==="
    ps aux --sort=-%mem | awk 'NR==1 || NR<=6' | column -t
    echo
}

# additonal stats
additional_stat(){
echo "OS Version :$(uname -a)"
echo "Uptime: $(uptime -p)"
echo "Logged in Users: $(who | wc -l)"
}


# Run all
get_cpu_usage
echo
get_memory_usage
echo
get_disk_usage
echo
get_cpu_top
echo
get_mem_top
echo
additional_stat
