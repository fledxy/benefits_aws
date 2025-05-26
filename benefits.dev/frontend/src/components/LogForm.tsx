import React, { useState } from 'react';
import {
  Box,
  TextField,
  Button,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Paper,
  Typography,
  Alert,
} from '@mui/material';
import axios from 'axios';

interface LogFormProps {
  onLogAdded: () => void;
}

const LogForm: React.FC<LogFormProps> = ({ onLogAdded }) => {
  const [message, setMessage] = useState('');
  const [level, setLevel] = useState('info');
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await axios.post('http://127.0.0.1:5000/api/logs', {
        message,
        level,
      });
      setMessage('');
      setLevel('info');
      setError(null);
      setSuccess(true);
      onLogAdded(); // Refresh the logs list
      
      // Clear success message after 3 seconds
      setTimeout(() => {
        setSuccess(false);
      }, 3000);
    } catch (err) {
      setError('Failed to add log. Please try again.');
      console.error('Error adding log:', err);
    }
  };

  return (
    <Paper sx={{ p: 3, mb: 3 }}>
      <Typography variant="h6" gutterBottom>
        Add New Log
      </Typography>
      
      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}
      
      {success && (
        <Alert severity="success" sx={{ mb: 2 }}>
          Log added successfully!
        </Alert>
      )}

      <Box component="form" onSubmit={handleSubmit}>
        <TextField
          fullWidth
          label="Message"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          required
          margin="normal"
        />

        <FormControl fullWidth margin="normal">
          <InputLabel>Log Level</InputLabel>
          <Select
            value={level}
            label="Log Level"
            onChange={(e) => setLevel(e.target.value)}
          >
            <MenuItem value="info">Info</MenuItem>
            <MenuItem value="warning">Warning</MenuItem>
            <MenuItem value="error">Error</MenuItem>
          </Select>
        </FormControl>

        <Button
          type="submit"
          variant="contained"
          color="primary"
          fullWidth
          sx={{ mt: 2 }}
        >
          Add Log
        </Button>
      </Box>
    </Paper>
  );
};

export default LogForm; 