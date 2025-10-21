# Deployment Guide

This guide covers the complete deployment process for the DevOps Task API.

## Prerequisites

1. **Docker and Docker Compose** installed
2. **OpenWeatherMap API Key** (free at https://openweathermap.org/api)
3. **Git** for version control
4. **GitHub Account** for repository hosting

## Local Development Setup

### 1. Environment Setup

```bash
# Clone the repository
git clone <your-repository-url>
cd devops-task-final

# Copy environment template
cp env.example .env

# Edit .env file and add your API key
nano .env
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Run Tests

```bash
npm test
```

### 4. Start Development Server

```bash
# Using npm
npm run dev

# Using Docker Compose
docker-compose --profile dev up --build
```

## Production Deployment

### 1. Build Production Image

```bash
docker build -t devops-task-api:latest .
```

### 2. Run with Docker Compose

```bash
# Set environment variables
export WEATHER_API_KEY=your_api_key_here
export IMAGE_NAME=devops-task-api
export VERSION=latest

# Deploy with load balancer
docker-compose -f docker-compose.prod.yml --profile production up -d
```

### 3. Zero-Downtime Deployment

```bash
# Make deployment script executable
chmod +x deploy.sh

# Deploy new version
./deploy.sh v1.0.1
```

## CI/CD Pipeline Setup

### 1. GitHub Repository Setup

1. Create a new public repository on GitHub
2. Push your code to the repository
3. Go to repository Settings > Secrets and variables > Actions

### 2. Required Secrets

Add the following secrets in GitHub:

- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_PASSWORD`: Your Docker Hub password/token
- `WEATHER_API_KEY`: Your OpenWeatherMap API key

### 3. Release Process

1. **Create a Release:**
   - Go to your repository
   - Click "Releases" > "Create a new release"
   - Create a new tag (e.g., `v1.0.0`)
   - Add release notes
   - Publish the release

2. **Automated Pipeline:**
   - The CI/CD pipeline will automatically trigger
   - Tests will run
   - Docker image will be built and pushed to Docker Hub
   - Image will be tagged with the release version

### 4. Verify Deployment

```bash
# Check API health
curl http://localhost:3000/api/health

# Check hello endpoint
curl http://localhost:3000/api/hello
```

## Monitoring and Maintenance

### Health Checks

The API includes comprehensive health checks:

- **Application Health:** `/api/health`
- **Docker Health Check:** Built into container
- **Load Balancer Health:** Nginx upstream checks

### Logs

```bash
# View application logs
docker-compose logs -f api

# View all service logs
docker-compose logs -f
```

### Scaling

```bash
# Scale API instances
docker-compose -f docker-compose.prod.yml up -d --scale api=3
```

## Security Considerations

1. **Environment Variables:** Never commit `.env` files
2. **API Keys:** Store in secure secret management
3. **Container Security:** Uses non-root user
4. **Network Security:** Configure firewalls appropriately
5. **Updates:** Regularly update base images and dependencies

## Troubleshooting

### Common Issues

1. **Weather API Failures:**
   - Check API key validity
   - Verify network connectivity
   - Check API rate limits

2. **Container Issues:**
   - Check Docker logs: `docker logs <container_name>`
   - Verify environment variables
   - Check port availability

3. **Health Check Failures:**
   - Verify application is running
   - Check health endpoint manually
   - Review application logs

### Debug Commands

```bash
# Check container status
docker ps

# View container logs
docker logs devops-task-api

# Test API endpoints
curl -v http://localhost:3000/api/health
curl -v http://localhost:3000/api/hello

# Check Docker Compose services
docker-compose ps
```

## Performance Optimization

1. **Resource Limits:** Set appropriate CPU/memory limits
2. **Caching:** Implement Redis for weather data caching
3. **CDN:** Use CDN for static assets
4. **Monitoring:** Implement APM tools (e.g., New Relic, DataDog)

## Backup and Recovery

1. **Configuration Backup:** Version control all config files
2. **Data Backup:** Regular database backups if applicable
3. **Image Backup:** Keep multiple image versions
4. **Disaster Recovery:** Document recovery procedures
