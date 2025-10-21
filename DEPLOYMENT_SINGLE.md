# Single Dockerfile & Docker Compose Deployment Guide

This guide covers deploying the DevOps Task API using a single, production-ready Dockerfile and docker-compose.yaml file.

## 🚀 Quick Start

### 1. Basic Production Deployment
```bash
# Set your environment variables
export WEATHER_API_KEY=your_api_key_here
export NODE_ENV=production

# Deploy the application
docker-compose up --build -d
```

### 2. Development Mode
```bash
# Run with hot reload for development
docker-compose --profile dev up --build
```

### 3. Production with Load Balancer
```bash
# Deploy with Nginx load balancer
docker-compose --profile production up --build -d
```

## 📁 File Structure

```
devops-task-final/
├── Dockerfile              # Single production-ready container
├── docker-compose.yaml     # Unified orchestration file
├── nginx.conf              # Load balancer configuration
├── env.production          # Environment template
└── server.js              # Application code
```

## 🔧 Configuration Options

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | `production` | Application environment |
| `PORT` | `3000` | Host port mapping |
| `HOSTNAME` | `server1` | Server hostname |
| `WEATHER_API_KEY` | Required | OpenWeatherMap API key |
| `REPLICAS` | `1` | Number of API replicas |
| `NGINX_PORT` | `80` | Load balancer port |
| `DEV_PORT` | `3001` | Development port |

### Deployment Profiles

#### Production (Default)
```bash
docker-compose up --build -d
```
- Single API container
- Production optimizations
- Health checks enabled
- Auto-restart on failure

#### Development
```bash
docker-compose --profile dev up --build
```
- Hot reload enabled
- Volume mounting for live code changes
- Development environment

#### Production with Load Balancer
```bash
docker-compose --profile production up --build -d
```
- Multiple API replicas
- Nginx load balancer
- Zero-downtime deployment ready

## 🛠️ Deployment Commands

### Basic Operations
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Scale API replicas
docker-compose up --scale api=3 -d
```

### Advanced Operations
```bash
# Rebuild without cache
docker-compose build --no-cache

# Update specific service
docker-compose up --build api -d

# View service status
docker-compose ps

# Execute commands in container
docker-compose exec api sh
```

## 🔍 Monitoring & Health Checks

### Health Check Endpoints
- **API Health**: `http://localhost:3000/api/health`
- **Application**: `http://localhost:3000/api/hello`
- **Load Balancer**: `http://localhost:80/health` (if using production profile)

### Container Health Status
```bash
# Check container health
docker ps

# View health check logs
docker inspect devops-task-final_api_1 --format='{{.State.Health.Status}}'

# Monitor logs
docker-compose logs -f api
```

## 🔒 Security Features

### Container Security
- ✅ Non-root user execution
- ✅ Minimal Alpine Linux base
- ✅ Security headers (Helmet.js)
- ✅ No unnecessary packages
- ✅ Read-only filesystem where possible

### Network Security
- ✅ Internal container networking
- ✅ Port mapping control
- ✅ Environment variable protection

## 📊 Performance Optimizations

### Container Optimizations
- ✅ Multi-stage build process
- ✅ Dependency caching
- ✅ Minimal image size
- ✅ Health check optimization
- ✅ Resource limits

### Application Optimizations
- ✅ Connection pooling
- ✅ Error handling
- ✅ Graceful shutdowns
- ✅ Memory management

## 🚨 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using the port
lsof -i :3000

# Kill the process
sudo kill -9 <PID>

# Or use a different port
PORT=3001 docker-compose up -d
```

#### Container Won't Start
```bash
# Check logs
docker-compose logs api

# Check container status
docker-compose ps

# Rebuild container
docker-compose build --no-cache api
```

#### Health Check Failures
```bash
# Test health endpoint manually
curl http://localhost:3000/api/health

# Check container health
docker inspect <container_name> --format='{{.State.Health}}'
```

### Debug Commands
```bash
# Enter container shell
docker-compose exec api sh

# Check environment variables
docker-compose exec api env

# Test API connectivity
docker-compose exec api node -e "console.log('API running')"
```

## 🔄 CI/CD Integration

### GitHub Actions
```yaml
- name: Deploy with Docker Compose
  run: |
    export WEATHER_API_KEY=${{ secrets.WEATHER_API_KEY }}
    docker-compose up --build -d
```

### Manual Deployment
```bash
# Production deployment
export WEATHER_API_KEY=your_api_key
export NODE_ENV=production
docker-compose up --build -d

# Verify deployment
curl http://localhost:3000/api/health
```

## 📈 Scaling

### Horizontal Scaling
```bash
# Scale to 3 replicas
docker-compose up --scale api=3 -d

# With load balancer
docker-compose --profile production up --scale api=3 -d
```

### Resource Limits
Add to docker-compose.yaml:
```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 256M
```

## 🎯 Production Checklist

- ✅ Environment variables configured
- ✅ API key set and working
- ✅ Health checks passing
- ✅ Container security enabled
- ✅ Resource limits set
- ✅ Monitoring configured
- ✅ Backup strategy in place
- ✅ CI/CD pipeline tested

Your DevOps Task API is now ready for production deployment! 🚀
