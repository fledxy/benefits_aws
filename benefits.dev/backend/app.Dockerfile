# Use a minimal, official Python base image
FROM python:3.10-slim-buster

# Set environment variables for security (prevents Python from writing .pyc files and buffering)
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

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
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt gunicorn

# Copy the rest of the application files
COPY . .

# Change ownership and permissions
USER root
RUN chown -R appuser:appgroup /app && chmod -R 755 /app

# Switch to non-root user
USER appuser

# Set the entrypoint and command
ENTRYPOINT ["gunicorn"]
CMD ["--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "120", "app:app"]