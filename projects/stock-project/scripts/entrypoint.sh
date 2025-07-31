#writing the shebang line
#!/bin/bash
set -e
echo " Starting the entrypoint script..."
# Print the current working directory
echo "Current working directory: $(pwd)"

# run initial health check
echo "Running initial health check..."
./scripts/healthcheck.sh || { echo "Initial health check failed"; exit 1; }

#setup the cron scheduler.sh
echo "Setting up the cron job but this time it runs the etl directly just for testing..."
./scripts/scheduler.sh || { echo "Failed to set up cron job"; exit 1; }



# Print a message indicating that the script has finished
echo "entrypoint script finished."
# Start the cron service in the foreground
echo "Starting cron service..."
cron -f