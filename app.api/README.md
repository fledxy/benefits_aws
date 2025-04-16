# Simple REST API

A simple REST API built with Flask and Docker.

## Endpoints

- `GET /`: Welcome message
- `GET /api/hello`: Returns a hello message
- `GET /api/health`: Health check endpoint

## Running with Docker

1. Build the Docker image:
```bash
docker build -t simple-api .
```

2. Run the container:
```bash
docker run -p 5000:5000 simple-api
```

3. Access the API:
- http://localhost:5000/
- http://localhost:5000/api/hello
- http://localhost:5000/api/health

## Running without Docker

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Run the application:
```bash
python app.py
```

The API will be available at http://localhost:5000 