#!/bin/bash

# Zero-downtime deployment script
# This script implements blue-green deployment strategy

set -e

# Configuration
IMAGE_NAME="devops-task-api"
CONTAINER_NAME="devops-task-api"
HEALTH_CHECK_URL="http://localhost:3000/api/health"
MAX_RETRIES=30
RETRY_INTERVAL=2

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if container is healthy
check_health() {
    local container_name=$1
    local max_retries=$2
    local retry_interval=$3
    
    print_status "Checking health of $container_name..."
    
    for ((i=1; i<=max_retries; i++)); do
        if docker exec "$container_name" curl -f "$HEALTH_CHECK_URL" >/dev/null 2>&1; then
            print_status "$container_name is healthy!"
            return 0
        fi
        
        if [ $i -lt $max_retries ]; then
            print_warning "Health check failed (attempt $i/$max_retries), retrying in ${retry_interval}s..."
            sleep $retry_interval
        fi
    done
    
    print_error "$container_name failed health checks after $max_retries attempts"
    return 1
}

# Function to stop and remove container
cleanup_container() {
    local container_name=$1
    
    if docker ps -q -f name="$container_name" | grep -q .; then
        print_status "Stopping $container_name..."
        docker stop "$container_name"
    fi
    
    if docker ps -aq -f name="$container_name" | grep -q .; then
        print_status "Removing $container_name..."
        docker rm "$container_name"
    fi
}

# Main deployment function
deploy() {
    local image_tag=$1
    
    if [ -z "$image_tag" ]; then
        print_error "Image tag is required"
        echo "Usage: $0 <image_tag>"
        exit 1
    fi
    
    print_status "Starting zero-downtime deployment with image: $IMAGE_NAME:$image_tag"
    
    # Check if the image exists
    if ! docker image inspect "$IMAGE_NAME:$image_tag" >/dev/null 2>&1; then
        print_error "Image $IMAGE_NAME:$image_tag not found"
        exit 1
    fi
    
    # Create new container with unique name
    local new_container_name="${CONTAINER_NAME}-new-$(date +%s)"
    local old_container_name="${CONTAINER_NAME}-old"
    
    print_status "Starting new container: $new_container_name"
    
    # Start new container
    docker run -d \
        --name "$new_container_name" \
        -p 3001:3000 \
        -e NODE_ENV=production \
        -e WEATHER_API_KEY="${WEATHER_API_KEY:-your_api_key}" \
        -e HOSTNAME=server1 \
        "$IMAGE_NAME:$image_tag"
    
    # Wait for new container to be healthy
    if ! check_health "$new_container_name" $MAX_RETRIES $RETRY_INTERVAL; then
        print_error "New container failed health checks, rolling back..."
        cleanup_container "$new_container_name"
        exit 1
    fi
    
    print_status "New container is healthy, proceeding with switch..."
    
    # Stop old container if it exists
    if docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        print_status "Stopping old container..."
        docker stop "$CONTAINER_NAME"
        docker rename "$CONTAINER_NAME" "$old_container_name"
    fi
    
    # Switch new container to production port
    print_status "Switching to new container..."
    docker stop "$new_container_name"
    docker run -d \
        --name "$CONTAINER_NAME" \
        -p 3000:3000 \
        -e NODE_ENV=production \
        -e WEATHER_API_KEY="${WEATHER_API_KEY:-your_api_key}" \
        -e HOSTNAME=server1 \
        "$IMAGE_NAME:$image_tag"
    
    # Final health check
    if check_health "$CONTAINER_NAME" $MAX_RETRIES $RETRY_INTERVAL; then
        print_status "Deployment successful!"
        
        # Clean up old container
        if docker ps -aq -f name="$old_container_name" | grep -q .; then
            print_status "Cleaning up old container..."
            docker rm "$old_container_name"
        fi
        
        # Clean up temporary container
        docker rm "$new_container_name"
        
        print_status "Zero-downtime deployment completed successfully!"
    else
        print_error "Final health check failed, rolling back..."
        
        # Rollback to old container if it exists
        if docker ps -aq -f name="$old_container_name" | grep -q .; then
            print_status "Rolling back to previous version..."
            cleanup_container "$CONTAINER_NAME"
            docker rename "$old_container_name" "$CONTAINER_NAME"
            docker start "$CONTAINER_NAME"
            
            if check_health "$CONTAINER_NAME" $MAX_RETRIES $RETRY_INTERVAL; then
                print_status "Rollback successful!"
            else
                print_error "Rollback failed!"
                exit 1
            fi
        else
            print_error "No previous version to rollback to!"
            exit 1
        fi
        
        # Clean up failed new container
        cleanup_container "$new_container_name"
    fi
}

# Run deployment
deploy "$1"
