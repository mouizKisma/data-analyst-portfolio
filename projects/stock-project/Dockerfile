# Base image (Python 3.9 slim for Apple Silicon)
FROM python:3.9-slim-bullseye



# Install system dependencies (required for psycopg2)
RUN apt-get update && apt-get install -y gcc cron && rm -rf /var/lib/apt/lists/*
RUN touch /var/log/stock-etl.log && chmod 666 /var/log/stock-etl.log
# Set working directory INSIDE container
WORKDIR /app
# Copy all project files into the container
COPY . .
# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt
# Make scripts executable
RUN chmod +x scripts/*.sh


# Default command when container starts
ENTRYPOINT ["/bin/bash", "scripts/entrypoint.sh"]