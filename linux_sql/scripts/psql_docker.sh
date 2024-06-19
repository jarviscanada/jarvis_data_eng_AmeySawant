#! /bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start docker
# Make sure you understand the double pipe operator
sudo systemctl status docker || systemctl start docker

# Check container status
docker container inspect jrvs-psql
container_status=$?

# User switch case to handle create|stop|start options
case $cmd in 
  create)
    # Check if the container is already created
    if [ $container_status -eq 0 ]; then
        echo 'Container already exists'
        exit 1
    fi
    
    # Check if username and password are provided
    if [ -z "$db_username" ] || [ -z "$db_password" ]; then
        echo 'Username and password are required for container creation'
        exit 1
    fi
    
    # Create volume
    docker volume create pgdata
    
    # Start the container with username and password environment variables
    docker run --name jrvs-psql -e POSTGRES_USER="$db_username" -e POSTGRES_PASSWORD="$db_password" -d postgres
    
    # Check if container creation was successful
    if [ $? -eq 0 ]; then
        echo 'Container created successfully'
    else
        echo 'Failed to create container'
        exit 1
    fi
    ;;

  start|stop)
    # Check if the container exists
    if [ $container_status -ne 0 ]; then
        echo 'Container does not exist'
        exit 1
    fi

    # Start or stop the container
    docker container $cmd jrvs-psql
    ;;

  *)
    echo 'Illegal command'
    echo 'Usage: ./scripts/psql_docker.sh start|stop|create [db_username] [db_password]'
    echo 'Examples:'
    echo './scripts/psql_docker.sh create db_username db_password'
    echo './scripts/psql_docker.sh start'
    echo './scripts/psql_docker.sh stop'
    exit 1
    ;;
esac

