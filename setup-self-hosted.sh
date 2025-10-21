#!/bin/bash

# Self-Hosted Runner Setup Script
# This script sets up a GitHub Actions self-hosted runner for DevOps Task API

set -e

echo "🚀 Setting up Self-Hosted GitHub Actions Runner"
echo "================================================"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root"
   exit 1
fi

# Repository information
GITHUB_USERNAME="naimuddin-bs23"
REPO_NAME="weather-api"
REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME"

echo "📋 Repository: $REPO_URL"
echo "📋 Please provide the runner token:"
read -p "Runner Token (from GitHub Settings > Actions > Runners): " RUNNER_TOKEN

if [[ -z "$RUNNER_TOKEN" ]]; then
    echo "❌ Runner token is required"
    exit 1
fi

echo ""
echo "🔧 Installing required software..."

# Update system
sudo apt update

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
else
    echo "✅ Docker already installed"
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "✅ Docker Compose already installed"
fi

# Install Node.js 18
if ! command -v node &> /dev/null || [[ $(node -v | cut -d'v' -f2 | cut -d'.' -f1) -lt 18 ]]; then
    echo "📦 Installing Node.js 18..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "✅ Node.js 18+ already installed"
fi

# Install Git
if ! command -v git &> /dev/null; then
    echo "📦 Installing Git..."
    sudo apt install git -y
else
    echo "✅ Git already installed"
fi

# Install curl
if ! command -v curl &> /dev/null; then
    echo "📦 Installing curl..."
    sudo apt install curl -y
else
    echo "✅ curl already installed"
fi

echo ""
echo "🏃 Setting up GitHub Actions Runner..."

# Create actions-runner directory
mkdir -p ~/actions-runner
cd ~/actions-runner

# Download the latest runner package
echo "📥 Downloading GitHub Actions Runner..."
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

# Extract the installer
echo "📦 Extracting runner package..."
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

# Configure the runner
echo "⚙️  Configuring runner..."
./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --name "self-hosted-runner" --work "_work"

# Install as a service
echo "🔧 Installing runner as service..."
sudo ./svc.sh install

# Start the service
echo "▶️  Starting runner service..."
sudo ./svc.sh start

echo ""
echo "🎉 Self-hosted runner setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Set up GitHub repository secrets:"
echo "   - WEATHER_API_KEY=abd9523d2a02b6fc7ae21bb4e7c86f4c"
echo ""
echo "2. Create a release in GitHub to trigger deployment"
echo ""
echo "3. Monitor runner status:"
echo "   sudo systemctl status actions.runner.*"
echo ""
echo "4. Check application after deployment:"
echo "   curl http://localhost:3000/api/health"
echo ""
echo "✅ Setup complete! Your self-hosted runner is ready."
