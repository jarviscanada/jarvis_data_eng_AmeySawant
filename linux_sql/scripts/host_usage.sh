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

# Construct the INSERT statement. (hint: use a subquery to get id by hostname)
hostname=$(hostname -f)
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"
insert_stmt="INSERT INTO host_usage (timestamp, host_id, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES ('$timestamp', $host_id, $cpu_idle, $cpu_kernel, $disk_io, $disk_available);"

# Execute the INSERT statement
export PGPASSWORD=$psql_password 
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?

