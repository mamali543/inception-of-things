#!/bin/bash

# Colors
BLUE='\033[1;34m'
LEMON='\033[38;5;226m'
CYAN='\033[0;36m'
PINK='\033[38;5;212m'
NC='\033[0m'

echo -e "${LEMON}==> INSTALLING GITLAB...${NC}"
cd /vagrant/confs
docker-compose up -d
echo -e "${BLUE}==> GITLAB INSTALLED.${NC}"

echo -e "${LEMON}==> CREATING GITLAB NAMESPACE...${NC}"
kubectl create namespace gitlab
echo -e "${BLUE}==> GITLAB NAMESPACE CREATED.${NC}"

echo -e "${LEMON}==> INSTALLING HELM...${NC}"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
echo -e "${BLUE}==> HELM INSTALLED.${NC}"

echo -e "${LEMON}==> ADDING GITLAB HELM REPOSITORY...${NC}"
helm repo add gitlab https://charts.gitlab.io/
helm repo update
echo -e "${BLUE}==> GITLAB HELM REPOSITORY ADDED.${NC}"

echo -e "${LEMON}==> INSTALLING GITLAB RUNNER IN THE CLUSTER...${NC}"
helm install --namespace gitlab gitlab-runner gitlab/gitlab-runner
echo -e "${BLUE}==> GITLAB RUNNER INSTALLED.${NC}"
