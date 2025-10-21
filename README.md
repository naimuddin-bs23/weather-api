# DevOps Task - Weather API

A comprehensive DevOps project implementing a REST API with automated CI/CD pipeline, containerization, and zero-downtime deployment.

## 🎯 Project Overview

This project demonstrates complete DevOps practices including:
- REST API development with Node.js
- Third-party API integration (OpenWeatherMap)
- Containerization with Docker
- CI/CD pipeline with GitHub Actions
- Self-hosted runner deployment
- Zero-downtime deployment strategy

## 🚀 Features

### REST API Endpoints
- **`/api/hello`** - Returns hostname, datetime, version, and weather data for Dhaka
- **`/api/health`** - Health check endpoint verifying API and external service status
- **`/`** - Root endpoint with API information

### Weather Integration
- Real-time weather data for Dhaka, Bangladesh
- OpenWeatherMap API integration
- Graceful fallback when external API is unavailable
- Error handling and retry mechanisms

### Containerization
- Production-optimized Dockerfile with Alpine Linux
- Non-root user for security
- Multi-stage builds for efficiency
- Health checks and monitoring

### CI/CD Pipeline
- Automated testing with Jest
- Docker image building and pushing to Docker Hub
- Release-based deployment triggers
- Version synchronization validation
- Zero-downtime deployment

## 📋 Requirements Fulfilled

### ✅ REST API Development
- [x] Node.js REST API with Express.js
- [x] `/api/hello` endpoint returning hostname, datetime, version, weather data
- [x] `/api/health` endpoint with API and external service health checks
- [x] JSON response format
- [x] Error handling and graceful degradation

### ✅ Third-Party API Integration
- [x] OpenWeatherMap API integration for Dhaka weather
- [x] API key management with environment variables
- [x] Fallback mechanism when external API fails
- [x] Health check for external service availability

### ✅ Containerization
- [x] Optimized Dockerfile for production
- [x] Docker Compose for development and deployment
- [x] Security hardening (non-root user, minimal attack surface)
- [x] Health checks and monitoring

### ✅ Version Control & CI/CD
- [x] GitHub repository with proper structure
- [x] GitHub Actions CI/CD pipeline
- [x] Self-hosted runner configuration
- [x] Release-based deployment triggers
- [x] Version matching between release tags and package.json

### ✅ Docker Registry Integration
- [x] Docker Hub registry integration
- [x] Automated image building and pushing
- [x] Tagged releases (v1.0.2, latest)
- [x] Token-based authentication

### ✅ Zero-Downtime Deployment
- [x] Docker Compose-based deployment
- [x] Health check verification
- [x] Automatic rollback on failure
- [x] Self-hosted runner deployment

## 🛠️ Technology Stack

- **Backend**: Node.js 18+, Express.js
- **Testing**: Jest, Supertest
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions
- **Registry**: Docker Hub
- **External API**: OpenWeatherMap
- **Security**: Helmet.js, non-root containers

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Docker and Docker Compose
- OpenWeatherMap API key
- Self-hosted GitHub Actions runner

### Local Development

1. **Clone Repository**
```bash
git clone git@github.com:naimuddin-bs23/weather-api.git
cd weather-api
```

2. **Install Dependencies**
```bash
npm install
```

3. **Environment Setup**
```bash
cp env.example .env
# Add your OpenWeatherMap API key to .env
```

4. **Start Development Server**
```bash
npm run dev
```

### Docker Development

```bash
# Build and run with Docker Compose
WEATHER_API_KEY=your_api_key docker-compose up --build

# For development with hot reload
WEATHER_API_KEY=your_api_key docker-compose --profile dev up --build
```

### Production Deployment

```bash
# Build production image
docker build -t naimjeem/weather-api:latest .

# Run container
docker run -p 3000:3000 \
  -e WEATHER_API_KEY=your_api_key \
  -e HOSTNAME=server1 \
  naimjeem/weather-api:latest
```

## 📊 API Documentation

### GET /api/hello
Returns system information and weather data for Dhaka.

**Response:**
```json
{
  "hostname": "server1",
  "datetime": "2510211430",
  "version": "1.0.2",
  "weather": {
    "dhaka": {
      "temperature": "34",
      "temp_unit": "c"
    }
  }
}
```

### GET /api/health
Returns health status of API and external services.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-21T14:30:00.000Z",
  "services": {
    "api": "healthy",
    "weather_api": "healthy"
  }
}
```

## 🔧 Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `NODE_ENV` | Environment mode | `development` | No |
| `PORT` | Server port | `3000` | No |
| `HOSTNAME` | Server hostname | `server1` | No |
| `WEATHER_API_KEY` | OpenWeatherMap API key | - | Yes |

## 🚀 CI/CD Pipeline

### Pipeline Jobs

1. **Test Job**
   - Runs Jest test suite
   - Validates version matching (release only)
   - Tests weather API integration

2. **Build and Push Job**
   - Builds Docker image
   - Pushes to Docker Hub registry
   - Tags with release version

3. **Deploy Job**
   - Deploys to self-hosted runner
   - Zero-downtime deployment
   - Health check verification

### Release Process

1. **Create Release**
   - Go to GitHub Releases
   - Create new release with tag (e.g., v1.0.2)
   - Pipeline automatically triggers

2. **Automated Deployment**
   - Tests run and validate
   - Docker image built and pushed
   - Deployment to self-hosted runner
   - Health verification

## 🔐 Security Features

- **Container Security**: Non-root user execution
- **HTTP Security**: Helmet.js security headers
- **Input Validation**: Request validation and sanitization
- **Environment Protection**: Secure environment variable handling
- **Minimal Attack Surface**: Alpine Linux base image

## 📈 Performance Optimizations

- **Lightweight Base**: Alpine Linux for smaller image size
- **Multi-stage Builds**: Optimized build process
- **Dependency Caching**: Efficient package management
- **Health Checks**: Container health monitoring
- **Error Handling**: Graceful degradation

## 🐳 Docker Images

- **Registry**: `docker.io/naimjeem/weather-api`
- **Tags**: `v1.0.2`, `latest`
- **Size**: ~50MB (Alpine Linux base)
- **Security**: Non-root user, minimal dependencies

## 📋 GitHub Secrets Required

Configure these secrets in your repository:

```
WEATHER_API_KEY=your_openweathermap_api_key
DOCKER_USERNAME=your_docker_hub_username
DOCKER_TOKEN=your_docker_hub_token
```

## 🎯 Deployment Architecture

```
GitHub Repository
       ↓
GitHub Actions (Self-hosted Runner)
       ↓
Docker Hub Registry
       ↓
Self-hosted Server
       ↓
Docker Compose Deployment
       ↓
Weather API (Port 3000)
```

## 📊 Monitoring & Health Checks

- **API Health**: `/api/health` endpoint
- **Container Health**: Docker health checks
- **External Service**: OpenWeatherMap API status
- **Deployment Status**: GitHub Actions workflow

## 🚀 Getting Started with Deployment

### 1. Setup Self-hosted Runner
```bash
# Follow GitHub documentation for self-hosted runner setup
# https://docs.github.com/en/actions/hosting-your-own-runners
```

### 2. Configure Secrets
Add required secrets in GitHub repository settings.

### 3. Create Release
Create a new release in GitHub to trigger deployment.

### 4. Monitor Deployment
Check GitHub Actions and verify API endpoints.

## 📝 Project Structure

```
weather-api/
├── .github/workflows/ci-cd.yml    # CI/CD pipeline
├── docker-compose.yaml            # Container orchestration
├── Dockerfile                     # Container definition
├── package.json                   # Dependencies and scripts
├── server.js                      # Main API application
├── test.js                        # Test suite
├── env.example                    # Environment template
├── nginx.conf                     # Load balancer config
└── README.md                      # This file
```

## 🎉 Success Criteria Met

- ✅ **REST API**: Complete with required endpoints
- ✅ **Weather Integration**: Real-time data with fallback
- ✅ **Containerization**: Production-ready Docker setup
- ✅ **CI/CD Pipeline**: Automated testing and deployment
- ✅ **Version Control**: Proper Git workflow
- ✅ **Zero-downtime**: Deployment strategy implemented
- ✅ **Self-hosted**: Runner configuration
- ✅ **Docker Registry**: Hub integration with token auth

## 📄 License

MIT License - See LICENSE file for details

## 👨‍💻 Author

**naimuddin-bs23** - DevOps Task Implementation

---

**Repository**: `git@github.com:naimuddin-bs23/weather-api.git`  
**Docker Hub**: `naimjeem/weather-api`  
**Status**: ✅ **Production Ready**
