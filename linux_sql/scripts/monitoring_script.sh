#!/bin/bash

# Hardware Specifications Data Collection
hostname=$(hostname -f)
lscpu_out=$(lscpu)
cpu_number=$(echo "$lscpu_out" | grep "^CPU(s):" | awk '{print $2}')
cpu_architecture=$(echo "$lscpu_out" | grep "Architecture:" | awk '{print $2}')
cpu_model=$(echo "$lscpu_out" | grep "Model name:" | awk -F': ' '{print $2}')
cpu_mhz=$(echo "$lscpu_out" | grep "CPU MHz:" | awk '{print $3}')
l2_cache=$(echo "$lscpu_out" | grep "L2 cache:" | awk '{print $3}')
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')
timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")

# Linux Resource Usage Data Collection
memory_free=$(vmstat --unit M | tail -1 | awk '{print $4}')
cpu_idle=$(vmstat 1 2 | tail -1 | awk '{print $15}')
cpu_kernel=$(vmstat 1 2 | tail -1 | awk '{print $14}')
disk_io=$(vmstat --unit M -d | tail -1 | awk '{print $10}')
disk_available=$(df -BM / | tail -1 | awk '{print $4}')

# Output the collected data
echo "Hardware Specifications:"
echo "Hostname: $hostname"
echo "CPU Number: $cpu_number"
echo "CPU Architecture: $cpu_architecture"
echo "CPU Model: $cpu_model"
echo "CPU MHz: $cpu_mhz"
echo "L2 Cache: $l2_cache"
echo "Total Memory: $total_mem MB"
echo "Timestamp: $timestamp"
echo
echo "Linux Resource Usage Data:"
echo "Memory Free: $memory_free MB"
echo "CPU Idle: $cpu_idle %"
echo "CPU Kernel: $cpu_kernel %"
echo "Disk I/O: $disk_io"
echo "Disk Available: $disk_available MB"

