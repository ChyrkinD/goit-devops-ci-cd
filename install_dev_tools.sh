#!/bin/bash

sudo apt update

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

sudo apt install -y docker-compose-plugin

sudo apt install -y python3 python3-pip python3-venv

python3 -m pip install --upgrade pip
python3 -m pip install django

echo "Successfully installed."
