#!/bin/bash

# Colors
BLUE='\033[1;34m'
LEMON='\033[38;5;226m'
CYAN='\033[0;36m'
PINK='\033[38;5;212m'
NC='\033[0m'

# echo -e "${LEMON}==> INSTALLING DOCKER COMPOSE...${NC}"
# sudo apt-get -y install docker-compose || { echo -e "${PINK}Failed to install Docker Compose.${NC}"; exit 1; }
# echo -e "${BLUE}==> DOCKER COMPOSE INSTALLED.${NC}"

# echo -e "${LEMON}==> INSTALLING GITLAB...${NC}"
# cd /vagrant/confs

# # Pull the Docker image with progress logging
# docker-compose pull gitlab || { echo -e "${PINK}Failed to pull GitLab image.${NC}"; exit 1; }

# # Start the container with progress logging
# docker-compose up -d || { echo -e "${PINK}Docker Compose failed to start GitLab.${NC}"; exit 1; }
# echo -e "${BLUE}==> GITLAB INSTALLED.${NC}"


##############################################

# echo -e "${LEMON}==> CREATING GITLAB NAMESPACE...${NC}"
# kubectl create namespace gitlab || { echo -e "${PINK}Failed to create namespace.${NC}"; exit 1; }
# echo -e "${BLUE}==> GITLAB NAMESPACE CREATED.${NC}"

# echo -e "${LEMON}==> INSTALLING HELM...${NC}"
# curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash || { echo -e "${PINK}Failed to install Helm.${NC}"; exit 1; }
# echo -e "${BLUE}==> HELM INSTALLED.${NC}"

# echo -e "${LEMON}==> ADDING GITLAB HELM REPOSITORY...${NC}"
# helm repo add gitlab https://charts.gitlab.io/ && helm repo update || { echo -e "${PINK}Failed to add/update GitLab Helm repository.${NC}"; exit 1; }
# echo -e "${BLUE}==> GITLAB HELM REPOSITORY ADDED.${NC}"

# echo -e "${LEMON}==> INSTALLING GITLAB RUNNER IN THE CLUSTER...${NC}"
# # Replace these placeholders with your actual values
# GITLAB_URL="http://gitlab.abayar.com"
# RUNNER_TOKEN="your-registration-token"

# DOMAIN="abayar.com"
# EMAIL="abayar@student.1337.ma"
# helm install gitlab gitlab/gitlab --set global.hosts.domain=$DOMAIN --set certmanager-issuer.email=$EMAIL --set postgresql.image.tag=13.6.0 --set global.hosts.externalIP=0.0.0.0  -n gitlab

# # helm install --namespace gitlab gitlab-runner gitlab/gitlab-runner \
# #   --set gitlabUrl=$GITLAB_URL,runnerRegistrationToken=$RUNNER_TOKEN || { echo -e "${PINK}Failed to install GitLab Runner.${NC}"; exit 1; }
# echo -e "${BLUE}==> GITLAB RUNNER INSTALLED.${NC}"

# # Wait for the GitLab Runner pod to be ready
# echo -e "${LEMON}==> WAITING FOR GITLAB RUNNER POD TO BE READY...${NC}"
# kubectl wait --for=condition=Ready pod -l app=gitlab-runner -n gitlab --timeout=600s || { echo -e "${PINK}GitLab Runner pod not ready.${NC}"; exit 1; }

# # Get the GitLab Runner pod name dynamically
# GITLAB_RUNNER_POD=$(kubectl get pods -n gitlab -l app=gitlab-runner -o jsonpath="{.items[0].metadata.name}")

# echo -e "${LEMON}==> FORWARDING PORT 9090 TO GITLAB RUNNER POD...${NC}"
# nohup sudo kubectl port-forward --address 0.0.0.0 -n gitlab $GITLAB_RUNNER_POD 9090:80 &


#post fix
# sudo apt-get update -y
echo -e "${LEMON}==> INSTALLING GITLAB...${NC}"

sudo apt-get update -y
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl -y
sudo ufw allow http
sudo ufw allow https
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo EXTERNAL_URL="http://local.gitlab.com" apt-get install gitlab-ee -y
#sudo gitlab-ctl reconfigure

sudo chown -R git:git /opt/gitlab/embedded/service/gitlab-rails
sudo chmod -R 755 /opt/gitlab/embedded/service/gitlab-rails

sudo gitlab-ctl reconfigure

sudo cat /etc/gitlab/initial_root_password | grep "Password"

echo -e "${BLUE}==> GITLAB INSTALLED.${NC}"
echo -e "${CYAN}SETUP COMPLETED.${NC}"


