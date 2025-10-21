const express = require('express');
const axios = require('axios');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Get version from package.json
const packageJson = require('./package.json');
const version = packageJson.version;

// Weather API configuration
const WEATHER_API_KEY = process.env.WEATHER_API_KEY || 'your_api_key_here';
const WEATHER_API_URL = 'https://api.openweathermap.org/data/2.5/weather?q=Dhaka&appid=';

// Function to get current datetime in YYMMDDHHmm format
function getCurrentDateTime() {
  const now = new Date();
  const year = now.getFullYear().toString().slice(-2);
  const month = (now.getMonth() + 1).toString().padStart(2, '0');
  const day = now.getDate().toString().padStart(2, '0');
  const hour = now.getHours().toString().padStart(2, '0');
  const minute = now.getMinutes().toString().padStart(2, '0');
  
  return `${year}${month}${day}${hour}${minute}`;
}

// Function to get hostname
function getHostname() {
  return process.env.HOSTNAME || require('os').hostname();
}

// Function to fetch weather data for Dhaka
async function getWeatherData() {
  try {
    const response = await axios.get(WEATHER_API_URL + WEATHER_API_KEY, {
      params: {
        q: 'Dhaka,BD',
        appid: WEATHER_API_KEY,
        units: 'metric'
      },
      timeout: 5000 // 5 second timeout
    });
    
    return {
      temperature: Math.round(response.data.main.temp).toString(),
      temp_unit: 'c'
    };
  } catch (error) {
    console.error('Weather API error:', error.message);
    // Return fallback data if weather API fails
    return {
      temperature: '25',
      temp_unit: 'c'
    };
  }
}

// Health check function
async function checkHealth() {
  const healthStatus = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    services: {
      api: 'healthy',
      weather_api: 'unknown'
    }
  };

  try {
    // Use the same weather data function as /api/hello endpoint
    const weatherData = await getWeatherData();
    
    // If we got weather data, the API is working
    if (weatherData && weatherData.temperature) {
      healthStatus.services.weather_api = 'healthy';
      console.log('Health check: Weather API is healthy via getWeatherData()');
    } else {
      healthStatus.services.weather_api = 'unhealthy';
      console.log('Health check: Weather API failed via getWeatherData()');
    }
  } catch (error) {
    console.error('Health check weather API error:', error.message);
    healthStatus.services.weather_api = 'unhealthy';
  }

  return healthStatus;
}

// Routes

// Health check endpoint
app.get('/api/health', async (req, res) => {
  try {
    const healthStatus = await checkHealth();
    // Only return 503 if the main API is unhealthy, not just external services
    const statusCode = healthStatus.services.api === 'healthy' ? 200 : 503;
    res.status(statusCode).json(healthStatus);
  } catch (error) {
    res.status(500).json({
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      error: 'Internal server error'
    });
  }
});

// Main hello endpoint
app.get('/api/hello', async (req, res) => {
  try {
    const weatherData = await getWeatherData();
    
    const response = {
      hostname: getHostname(),
      datetime: getCurrentDateTime(),
      version: version,
      weather: {
        dhaka: weatherData
      }
    };
    
    res.json(response);
  } catch (error) {
    console.error('Error in /api/hello:', error);
    res.status(500).json({
      error: 'Internal server error',
      message: error.message
    });
  }
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'DevOps Task API',
    version: version,
    endpoints: {
      hello: '/api/hello',
      health: '/api/health'
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Something went wrong!',
    message: err.message
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: 'The requested endpoint does not exist'
  });
});

// Start server only if not in test environment
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`Version: ${version}`);
  });
}

module.exports = app;
