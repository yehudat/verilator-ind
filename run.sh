#!/bin/bash
# Convenience script to run the Verilator container

set -e

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running"
    exit 1
fi

# Build if needed
if ! docker images | grep -q verilator-gtkwave; then
    echo "Building Docker image..."
    docker-compose build
fi

# Set up X11 forwarding based on OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Setting up X11 for Linux..."
    xhost +local:docker
    docker-compose run --rm verilator
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Setting up X11 for macOS..."
    echo "Make sure XQuartz is running and 'Allow connections from network clients' is enabled"
    IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
    xhost + $IP
    docker run -it --rm \
        -v $(pwd)/project:/project \
        -e DISPLAY=$IP:0 \
        verilator-gtkwave:latest
else
    echo "For Windows/WSL2, please run docker-compose manually"
    docker-compose run --rm verilator
fi
