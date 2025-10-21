# Weather API

A REST API built with Node.js that provides weather information and health checks for Dhaka, Bangladesh.

**Repository**: `git@github.com:naimuddin-bs23/weather-api.git`

## Features

- **REST API Endpoints:**
  - `/api/hello` - Returns hostname, datetime, version, and weather data for Dhaka
  - `/api/health` - Health check endpoint that verifies API and weather service status
  - `/` - Root endpoint with API information

- **Weather Integration:**
  - Fetches real-time weather data for Dhaka from OpenWeatherMap API
  - Fallback temperature data if weather API is unavailable

- **Containerization:**
  - Optimized Dockerfile for production
  - Development Dockerfile with hot reload
  - Docker Compose for easy development setup

- **CI/CD Pipeline:**
  - Automated testing and building
  - Docker image creation and pushing to registry
  - Release-based deployment triggers

## Quick Start

### Prerequisites

- Node.js 18+
- Docker and Docker Compose
- OpenWeatherMap API key (free at https://openweathermap.org/api)

### Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd devops-task-final
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
```bash
cp env.example .env
# Edit .env and add your OpenWeatherMap API key
```

4. Start the development server:
```bash
npm run dev
```

### Docker Development

1. Build and run with Docker Compose:
```bash
docker-compose up --build
```

2. For development with hot reload:
```bash
docker-compose --profile dev up --build
```

### Production Deployment

1. Build the production image:
```bash
docker build -t devops-task-api .
```

2. Run the container:
```bash
docker run -p 3000:3000 \
  -e WEATHER_API_KEY=your_api_key \
  -e HOSTNAME=server1 \
  devops-task-api
```

## API Endpoints

### GET /api/hello

Returns system information and weather data.

**Response:**
```json
{
  "hostname": "server1",
  "datetime": "2412011430",
  "version": "1.0.0",
  "weather": {
    "dhaka": {
      "temperature": "25",
      "temp_unit": "c"
    }
  }
}
```

### GET /api/health

Returns health status of the API and external services.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-12-01T14:30:00.000Z",
  "services": {
    "api": "healthy",
    "weather_api": "healthy"
  }
}
```

## Environment Variables

- `NODE_ENV` - Environment (development/production)
- `PORT` - Server port (default: 3000)
- `HOSTNAME` - Server hostname (default: server1)
- `WEATHER_API_KEY` - OpenWeatherMap API key (required)

## CI/CD Pipeline

The pipeline automatically:

1. **Tests** - Runs tests on every push and PR
2. **Builds** - Creates Docker images on release
3. **Deploys** - Pushes images to Docker registry
4. **Version Sync** - Ensures release version matches API version

### Release Process

1. Create a new release in GitHub
2. The pipeline automatically builds and pushes Docker images
3. Images are tagged with the release version
4. Zero-downtime deployment is supported

## Security Features

- Non-root user in Docker containers
- Helmet.js for security headers
- Input validation and error handling
- Environment variable protection
- Minimal attack surface

## Performance Optimizations

- Alpine Linux base image
- Multi-stage builds
- Dependency caching
- Health checks
- Graceful error handling

## License

MIT License
