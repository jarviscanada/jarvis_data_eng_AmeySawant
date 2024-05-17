#!/bin/bash

# Setup and validate arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check # of args
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

# Parse server CPU and memory usage data using bash scripts
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
cpu_idle=$(vmstat 1 2 | tail -1 | awk '{print $15}')
cpu_kernel=$(vmstat 1 2 | tail -1 | awk '{print $14}')
disk_io=$(vmstat -d | tail -1 | awk '{print $10}')
disk_available=$(df -BM / | tail -1 | awk '{print $4}' | sed 's/.$//')

# Retrieve host_id from host_info table based on the hostname
hostname=$(hostname -f)
host_id=$(psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -t -c "SELECT id FROM host_info WHERE hostname = '$hostname';")

# Check if host_id is null
if [ -z "$host_id" ]; then
    echo "Failed to retrieve host_id for hostname: $hostname"
    exit 1
fi

# Construct the INSERT statement with the correct host_id value
insert_stmt="INSERT INTO host_usage (timestamp, host_id, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES ('$timestamp', $host_id, $cpu_idle, $cpu_kernel, $disk_io, $disk_available);"

# Execute the INSERT statement
export PGPASSWORD=$psql_password 
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
