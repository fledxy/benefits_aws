import psycopg2
import os

def try_connect():
    try:
        conn = psycopg2.connect(
            dbname="benefits_db",  # Kết nối đến database mặc định
            user="benefits",    # Sử dụng user postgres
            password="postgres",
            host="postgres",
            port="5432"
        )
        print("Successfully connected to database")
        return conn
    except Exception as e:
        print(f"Failed to connect: {str(e)}")
        return None

# Try to connect
conn = try_connect()
if conn:
    # If connection successful, create user and database
    conn.autocommit = True
    cur = conn.cursor()
    
    # Create user if not exists
    cur.execute("SELECT 1 FROM pg_roles WHERE rolname = 'benefits'")
    if not cur.fetchone():
        cur.execute("CREATE USER benefits WITH PASSWORD 'postgres'")
        print("Created user benefits")
    
    # Create database if not exists
    cur.execute("SELECT 1 FROM pg_database WHERE datname = 'benefits_db'")
    if not cur.fetchone():
        cur.execute('CREATE DATABASE benefits_db')
        print("Created benefits_db database")
    
    # Grant privileges
    cur.execute("GRANT ALL PRIVILEGES ON DATABASE benefits_db TO benefits")
    print("Granted privileges to user benefits")
    
    cur.close()
    conn.close() 