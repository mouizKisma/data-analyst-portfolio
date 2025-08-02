#!/bin/bash

echo "Running health check..."
# check python is installed
if ! command -v python &> /dev/null; then
    echo "Python is not installed. Exiting health check."
    exit 1
fi

#check database connection
python -c "
import psycopg2; psycopg2.connect(
    host='$DB_HOST',
    port='$DB_PORT',
    dbname='$DB_NAME',
    user='$DB_USER',
    password='$DB_PASSWORD'
)" &> /dev/null
if [ $? -ne 0 ]; then
    echo "Database connection failed. Exiting health check."
    exit 1
fi
echo "Health check passed successfully."