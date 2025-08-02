#!/bin/bash
# This script is used to schedule the execution of the main.py script 
#echo "starting the scheduler.sh script..."
#1 create a cron job
#echo "0 21 * * * /usr/local/bin/python /app/etl.py >> /var/log/stock-etl.log 2>&1" > /etc/cron.d/stock-etl
#2 give execution rights on the cron job
#chmod 0644 /etc/cron.d/stock-etl

#!/bin/bash
echo "starting the scheduler.sh script..."
# Skip cron setup and run directly
echo "Running ETL directly..."
/usr/local/bin/python /app/etl.py