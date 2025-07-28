#!/bin/bash

set -e

echo "🔧 Updating packages..."
sudo apt update

echo "📦 Installing dependencies..."
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  software-properties-common \
  nano \
  git \
  btop

echo "🔐 Adding Docker's GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "📄 Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Updating package list for Docker..."
sudo apt update

echo "🐳 Installing Docker Engine and Compose plugin..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "👤 Adding svradmin to docker group..."
sudo usermod -aG docker svradmin

echo "🚀 Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "✅ All done. You may need to log out and back in for svradmin's Docker permissions to take effect."
