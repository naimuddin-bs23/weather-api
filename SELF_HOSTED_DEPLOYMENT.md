# Self-Hosted Deployment Guide

This guide covers deploying the DevOps Task API using self-hosted GitHub Actions runners.

## 🏠 **Self-Hosted Runner Setup**

### 1. **Prerequisites**
- Linux server (Ubuntu 20.04+ recommended)
- Docker and Docker Compose installed
- Node.js 18+ installed
- Git installed
- Port 3000 available

### 2. **Install Required Software**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Git
sudo apt install git -y

# Logout and login to apply Docker group changes
```

### 3. **Setup GitHub Self-Hosted Runner**

```bash
# Create actions-runner directory
mkdir actions-runner && cd actions-runner

# Download the latest runner package
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

# Configure the runner
./config.sh --url https://github.com/YOUR_USERNAME/YOUR_REPO --token YOUR_RUNNER_TOKEN

# Install as a service
sudo ./svc.sh install

# Start the service
sudo ./svc.sh start
```

## 🔧 **Environment Configuration**

### 1. **GitHub Repository Secrets**

Set these secrets in your GitHub repository settings:

```bash
# Required secrets:
WEATHER_API_KEY=abd9523d2a02b6fc7ae21bb4e7c86f4c

# Optional secrets (if using external registry):
DOCKER_USERNAME=your_docker_hub_username
DOCKER_PASSWORD=your_docker_hub_token
```

### 2. **Self-Hosted Runner Environment**

Create environment file on your runner:

```bash
# Create environment file
cat > /home/runner/.env << EOF
NODE_ENV=production
PORT=3000
HOSTNAME=server1
WEATHER_API_KEY=abd9523d2a02b6fc7ae21bb4e7c86f4c
EOF
```

## 🚀 **Deployment Process**

### 1. **Automatic Deployment (Recommended)**

```bash
# Create a release in GitHub with tag v1.0.0
# The pipeline will automatically:
# 1. Run tests
# 2. Build Docker image
# 3. Deploy with Docker Compose
# 4. Verify deployment
```

### 2. **Manual Deployment**

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

# Set environment variables
export WEATHER_API_KEY=abd9523d2a02b6fc7ae21bb4e7c86f4c
export NODE_ENV=production

# Deploy with Docker Compose
docker-compose up --build -d

# Verify deployment
curl http://localhost:3000/api/health
```

## 🔍 **Monitoring & Management**

### 1. **Check Runner Status**

```bash
# Check if runner is running
sudo systemctl status actions.runner.*

# View runner logs
sudo journalctl -u actions.runner.* -f
```

### 2. **Check Application Status**

```bash
# Check running containers
docker ps

# View application logs
docker-compose logs -f

# Check health endpoint
curl http://localhost:3000/api/health
```

### 3. **Update Application**

```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up --build -d
```

## 🛠️ **Troubleshooting**

### Common Issues

#### Runner Not Starting
```bash
# Check runner configuration
cd actions-runner
./config.sh --help

# Reconfigure if needed
./config.sh --url https://github.com/YOUR_USERNAME/YOUR_REPO --token NEW_TOKEN
```

#### Docker Permission Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again
# Or run: newgrp docker
```

#### Port Already in Use
```bash
# Check what's using port 3000
sudo lsof -i :3000

# Kill the process
sudo kill -9 <PID>

# Or use different port
PORT=3001 docker-compose up -d
```

#### Health Check Failures
```bash
# Check container logs
docker logs devops-task-final_api_1

# Test API manually
curl -v http://localhost:3000/api/health
```

## 🔒 **Security Considerations**

### 1. **Runner Security**
- Keep runner software updated
- Use dedicated user for runner
- Limit network access
- Regular security updates

### 2. **Application Security**
- Non-root container execution
- Environment variable protection
- Network isolation
- Regular image updates

### 3. **Network Security**
- Firewall configuration
- SSL/TLS termination (if needed)
- Access control
- Monitoring and logging

## 📊 **Performance Optimization**

### 1. **Resource Limits**
```yaml
# Add to docker-compose.yaml
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 256M
```

### 2. **Scaling**
```bash
# Scale to multiple replicas
docker-compose up --scale api=3 -d

# Use load balancer profile
docker-compose --profile production up -d
```

## 🎯 **Production Checklist**

- ✅ Self-hosted runner configured and running
- ✅ Docker and Docker Compose installed
- ✅ GitHub secrets configured
- ✅ Environment variables set
- ✅ Health checks passing
- ✅ Monitoring configured
- ✅ Backup strategy in place
- ✅ Security measures implemented

## 🚀 **Quick Start Commands**

```bash
# Start deployment
WEATHER_API_KEY=abd9523d2a02b6fc7ae21bb4e7c86f4c docker-compose up -d

# Check status
docker ps && curl http://localhost:3000/api/health

# View logs
docker-compose logs -f

# Stop deployment
docker-compose down
```

Your DevOps Task API is now ready for self-hosted deployment! 🎉
