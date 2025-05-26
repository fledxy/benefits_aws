import psycopg2
import os

def try_connect(password):
    try:
        conn = psycopg2.connect(
            dbname="postgres",
            user="postgres",
            password=password,
            host="localhost",
            port="5432"
        )
        print(f"Successfully connected with password: {password}")
        return conn
    except Exception as e:
        print(f"Failed with password '{password}': {str(e)}")
        return None

# List of common default passwords to try
passwords = [
    "postgres",
    "admin",
    "password",
    "123456",
    "",  # empty password
    "postgresql",
    "root"
]

# Try each password
for password in passwords:
    conn = try_connect(password)
    if conn:
        # If connection successful, create database
        conn.autocommit = True
        cur = conn.cursor()
        cur.execute("SELECT 1 FROM pg_database WHERE datname = 'benefits_db'")
        exists = cur.fetchone()
        if not exists:
            cur.execute('CREATE DATABASE benefits_db')
            print("Created benefits_db database!")
        cur.close()
        conn.close()
        break 