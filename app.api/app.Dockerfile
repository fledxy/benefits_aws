# Use a minimal, official Python base image
FROM python:3.10-slim-buster

# Set a non-root user for security
RUN groupadd --system appgroup && useradd --system --create-home --gid appgroup appuser

# Update, install dependencies, then clean up to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    gcc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy and install dependencies securely
COPY --chown=appuser:appgroup app.api/requirements.txt .
RUN pip3 install --no-cache-dir --requirement requirements.txt

# Copy the rest of the application files
# COPY --chown=appuser:appgroup . .

# Change ownership and permissions
RUN chmod -R 755 /app

# Switch to non-root user
USER appuser

# Set the entrypoint and command
ENTRYPOINT [ "python3" ]
CMD [ "app.api/app.py" ]
