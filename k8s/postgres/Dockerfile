FROM postgres:15

# Copy custom configuration
COPY postgresql.conf /etc/postgresql/postgresql.conf

# Set environment variables
ENV POSTGRES_DB=benefits_db \
    POSTGRES_USER=benefits \
    POSTGRES_PASSWORD=postgres

# Expose PostgreSQL port
EXPOSE 5432

# Use custom configuration
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"] 