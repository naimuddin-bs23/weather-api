# Weather API - Self-Hosted Deployment Guide

## 🎯 **Repository Information**
- **Repository**: `git@github.com:naimuddin-bs23/weather-api.git`
- **Image Name**: `weather-api`
- **Registry**: `localhost:5000`

## 🚀 **Quick Setup for Your Repository**

### **Step 1: Setup Self-Hosted Runner**
```bash
# Clone your repository
git clone git@github.com:naimuddin-bs23/weather-api.git
cd weather-api

# Run the automated setup script
./setup-self-hosted.sh

# The script will ask for:
# - Runner Token (from GitHub Settings > Actions > Runners)
```

### **Step 2: Configure GitHub Secrets**
Go to your repository settings: `https://github.com/naimuddin-bs23/weather-api/settings/secrets/actions`

Add the following secret:
```
WEATHER_API_KEY=abd9523d2a02b6fc7ae21bb4e7c86f4c
```

### **Step 3: Get Runner Token**
1. Go to `https://github.com/naimuddin-bs23/weather-api/settings/actions/runners`
2. Click "New self-hosted runner"
3. Select "Linux" and "x64"
4. Copy the token from the configuration command

### **Step 4: Deploy**
```bash
# Create a release in GitHub
# Go to: https://github.com/naimuddin-bs23/weather-api/releases
# Click "Create a new release"
# Tag: v1.0.0
# Title: Release v1.0.0
# Description: Initial release
# Click "Publish release"

# The pipeline will automatically:
# 1. Run tests
# 2. Build Docker image
# 3. Deploy to your self-hosted runner
# 4. Verify deployment
```

## 🔧 **Manual Deployment (Alternative)**

If you prefer manual deployment:

```bash
# Clone repository
git clone git@github.com:naimuddin-bs23/weather-api.git
cd weather-api

# Set environment variables
export WEATHER_API_KEY=abd9523d2a02b6fc7ae21bb4e7c86f4c
export NODE_ENV=production

# Deploy with Docker Compose
docker-compose up --build -d

# Verify deployment
curl http://localhost:3000/api/health
curl http://localhost:3000/api/hello
```

## 📊 **API Endpoints**

Once deployed, your API will be available at:

- **Health Check**: `http://localhost:3000/api/health`
- **Weather API**: `http://localhost:3000/api/hello`
- **Root Info**: `http://localhost:3000/`

### **Expected Response from /api/hello**
```json
{
  "hostname": "server1",
  "datetime": "2510210632",
  "version": "1.0.0",
  "weather": {
    "dhaka": {
      "temperature": "34",
      "temp_unit": "c"
    }
  }
}
```

## 🔍 **Monitoring Your Deployment**

### **Check Runner Status**
```bash
# Check if runner is running
sudo systemctl status actions.runner.*

# View runner logs
sudo journalctl -u actions.runner.* -f
```

### **Check Application Status**
```bash
# Check running containers
docker ps

# View application logs
docker-compose logs -f

# Test API endpoints
curl http://localhost:3000/api/health
curl http://localhost:3000/api/hello
```

### **Check GitHub Actions**
Visit: `https://github.com/naimuddin-bs23/weather-api/actions`

## 🛠️ **Troubleshooting**

### **Common Issues**

#### Runner Not Starting
```bash
# Check runner configuration
cd ~/actions-runner
./config.sh --help

# Reconfigure if needed
./config.sh --url https://github.com/naimuddin-bs23/weather-api --token NEW_TOKEN
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

## 🎯 **Repository-Specific Commands**

### **Update Repository**
```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up --build -d
```

### **Check Repository Status**
```bash
# Check git status
git status

# Check remote
git remote -v

# Should show:
# origin  git@github.com:naimuddin-bs23/weather-api.git (fetch)
# origin  git@github.com:naimuddin-bs23/weather-api.git (push)
```

## 🎉 **Success Indicators**

Your deployment is successful when:

- ✅ **Runner Status**: `sudo systemctl status actions.runner.*` shows "active"
- ✅ **Container Status**: `docker ps` shows running container
- ✅ **Health Check**: `curl http://localhost:3000/api/health` returns healthy status
- ✅ **Weather API**: `curl http://localhost:3000/api/hello` returns weather data
- ✅ **GitHub Actions**: Shows successful pipeline runs

## 📋 **Next Steps**

1. **Setup Runner**: Run `./setup-self-hosted.sh`
2. **Configure Secrets**: Add `WEATHER_API_KEY` in GitHub settings
3. **Create Release**: Create v1.0.0 release in GitHub
4. **Monitor**: Check deployment status and logs
5. **Verify**: Test API endpoints

Your Weather API is now ready for self-hosted deployment! 🚀
