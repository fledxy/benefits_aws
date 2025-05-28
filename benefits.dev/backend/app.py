from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime
import os
from dotenv import load_dotenv
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

def get_database_url():
    """
    Get database URL from environment variable or use default value
    Returns:
        str: Database connection URL
    """
    default_url = 'postgresql://postgres:postgres@postgres:5432/benefits_db'
    db_url = os.getenv('DATABASE_URL', default_url)
    logger.info(f"Using database URL: {db_url}")
    return db_url

app = Flask(__name__)
# Configure CORS to allow requests from multiple origins
CORS(app, resources={r"/*": {
    "origins": [
        "http://0.0.0.0:3000",
        "http://localhost:3000",
        os.getenv('FRONTEND_URL', 'http://localhost:3000')
    ],
    "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    "allow_headers": ["Content-Type", "Authorization"]
}})

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = get_database_url()
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Log model
class Log(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    message = db.Column(db.String(500), nullable=False)
    level = db.Column(db.String(20), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'message': self.message,
            'level': self.level,
            'timestamp': self.timestamp.isoformat()
        }

# Create tables
with app.app_context():
    db.create_all()

@app.route('/')
def home():
    return jsonify({
        'message': 'Welcome to Benefits Log API',
        'endpoints': {
            'get_logs': '/api/logs (GET)',
            'create_log': '/api/logs (POST)'
        }
    })

@app.route('/api/logs', methods=['GET'])
def get_logs():
    logs = Log.query.order_by(Log.timestamp.desc()).all()
    return jsonify([log.to_dict() for log in logs])

@app.route('/api/logs', methods=['POST'])
def create_log():
    data = request.json
    new_log = Log(
        message=data['message'],
        level=data['level']
    )
    db.session.add(new_log)
    db.session.commit()
    return jsonify(new_log.to_dict()), 201

if __name__ == '__main__':
    debug_mode = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    port = int(os.getenv('PORT', 5000))
    logger.info(f"Starting Flask application on port {port} (debug={debug_mode})")
    app.run(host='0.0.0.0', debug=debug_mode, port=port) 