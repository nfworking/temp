#!/bin/bash

TARGET="svradmin@172.168.1.4"

ssh "$TARGET" 'bash -s' <<'ENDSSH'
set -e

echo "🔧 Updating system and installing prerequisites..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common nano git btop

echo "📁 Creating keyring directory..."
sudo mkdir -p /etc/apt/keyrings

echo "🔐 Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "📄 Adding Docker APT repository (using jammy for compatibility)..."
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Updating apt cache again..."
sudo apt update

echo "🐳 Installing Docker Engine, Compose plugin, and tools..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "👤 Adding svradmin to docker group..."
sudo usermod -aG docker svradmin

echo "🚀 Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "✅ Docker installation complete on $(hostname). You may need to log out/in for docker group changes."
ENDSSH
