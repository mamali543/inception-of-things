#!/bin/bash

# Colors
BLUE='\033[1;34m'
LEMON='\033[38;5;226m'
CYAN='\033[0;36m'
PINK='\033[38;5;212m'
NC='\033[0m'

echo -e "${LEMON}==> INSTALLING DOCKER...${NC}"
sudo apt-get update -y
sudo curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo -e "${BLUE}==> DONE INSTALLING DOCKER.${NC}"

echo -e "${LEMON}==> INSTALLING KUBECTL...${NC}"
# Determine the architecture
ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
  ARCH="amd64"
else
  ARCH="arm64"
fi

# Download the correct kubectl binary
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/$ARCH/kubectl"
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo kubectl version --client
echo -e "${BLUE}==> DONE INSTALLING KUBECTL.${NC}"

echo -e "${PINK}==> INSTALLING K3D...${NC}"
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo -e "${BLUE}==> DONE INSTALLING K3D.${NC}"

echo -e "${PINK}==> CREATING K3D CLUSTER...${NC}"
sudo k3d cluster create IoT -p "8888:30080"
sleep 5
echo -e "${BLUE}==> K3D CLUSTER CREATED.${NC}"

echo -e "${LEMON}==> CREATING ARGOCD NAMESPACE...${NC}"
sudo kubectl create namespace argocd
sleep 5
echo -e "${BLUE}==> ARGOCD NAMESPACE CREATED.${NC}"

echo -e "${LEMON}==> INSTALLING ARGOCD IN THE K3D CLUSTER...${NC}"
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sudo kubectl wait -n argocd --for=condition=Ready pods --all --timeout=120s
echo -e "${BLUE}==> ARGOCD INSTALLED IN THE K3D CLUSTER.${NC}"

echo -e "${PINK}==> Getting ArgoCD password...${NC}"
sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo

sudo kubectl apply -f /vagrant/confs/app.yaml
echo -e "${CYAN}SETUP COMPLETED.${NC}"

# sudo kubectl port-forward --address 0.0.0.0 -n argocd svc/argocd-server 9090:443 &
nohup sudo kubectl port-forward --address 0.0.0.0 -n argocd svc/argocd-server 9900:443 > /vagrant/logs/port-forward.log 2>&1 &

sleep 5
# echo -e "${LEMON}==> INSTALLING GITLAB...${NC}"

