from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)
# Configure CORS to allow requests from frontend
CORS(app, resources={r"/*": {"origins": ["http://0.0.0.0:3000"]}})

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@postgres:5432/benefits_db')
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
    app.run(host='0.0.0.0', debug=True, port=5000) 