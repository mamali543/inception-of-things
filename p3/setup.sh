#!/bin/bash

# Colors
BLUE='\033[1;34m'
LEMON='\033[38;5;226m'
CYAN='\033[0;36m'
PINK='\033[38;5;212m'  # Light pink
NC='\033[0m' # No Color

echo -e "${LEMON} INSTALLING DOCKER...${NC}"
sudo apt-get update -y
sudo curl -fsSL test.docker.com -o get-docker.sh && sh get-docker.sh
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo -e "${BLUE}$ DONE INSTALLING DOCKER.${NC}"

echo -e "${LEMON} INSTALLING KUBECTL...${NC}"
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl"
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo kubectl version --client
echo -e "${BLUE}$ DONE INSTALLING KUBECTL.${NC}"

echo -e "${PINK} INSTALLING K3D...${NC}"
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo -e "${BLUE}$ DONE INSTALLING K3D.${NC}"

echo -e "${CYAN}SETUP COMPLETED.${NC}"