# Benefits Log Viewer

A full-stack application for viewing and managing logs, built with Flask and React.

## Project Structure

```
benefits/
├── backend/         # Flask backend
│   ├── app.py
│   └── requirements.txt
└── frontend/        # React frontend
    ├── src/
    │   ├── components/
    │   └── App.tsx
    └── package.json
```

## Backend Setup

1. Create a PostgreSQL database named `benefits_db`
2. Navigate to the backend directory:
   ```bash
   cd backend
   ```
3. Create a virtual environment and activate it:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
4. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
5. Create a `.env` file with the following content:
   ```
   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/benefits_db
   FLASK_ENV=development
   ```
6. Run the Flask application:
   ```bash
   python app.py
   ```

## Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the development server:
   ```bash
   npm start
   ```

The application will be available at:
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000

## Features

- Real-time log viewing
- Automatic log refresh every 5 seconds
- Color-coded log levels
- Responsive design
- RESTful API endpoints for log management 