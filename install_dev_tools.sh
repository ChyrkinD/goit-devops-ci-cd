#!/bin/bash

set -e

echo "Starting installation process..."

if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed."
fi

if ! docker compose version &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo apt update && sudo apt install -y docker-compose-plugin
else
    echo "Docker Compose is already installed."
fi

REQUIRED_MAJOR=3
REQUIRED_MINOR=9

if command -v python3 &> /dev/null; then
    VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    MAJOR=$(echo $VERSION | cut -d. -f1)
    MINOR=$(echo $VERSION | cut -d. -f2)

    if [ "$MAJOR" -eq "$REQUIRED_MAJOR" ] && [ "$MINOR" -ge "$REQUIRED_MINOR" ] || [ "$MAJOR" -gt "$REQUIRED_MAJOR" ]; then
        echo "Python $VERSION is already installed."
    else
        echo "Error: Python 3.9 or higher is required. Current version: $VERSION."
        exit 1
    fi
else
    echo "Python 3 not found. Installing..."
    sudo apt update && sudo apt install -y python3 python3-full
fi

if ! command -v pip3 &> /dev/null; then
    echo "Installing pip..."
    sudo apt install -y python3-pip
else
    echo "pip is already installed."
fi

PROJECT_DIR="my_django_project"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Creating project directory and setting up virtual environment..."
    mkdir -p $PROJECT_DIR
    cd $PROJECT_DIR
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install django
    echo "Django successfully installed in a virtual environment at $PROJECT_DIR."
else
    echo "Project directory already exists. Skipping Django installation."
fi

echo "All tasks completed successfully."