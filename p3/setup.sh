#!/bin/bash

# Colors
BLUE='\033[1;34m'
LEMON='\033[38;5;226m'
CYAN='\033[0;36m'
PINK='\033[38;5;212m'  # Light pink
NC='\033[0m' # No Color

echo -e "${LEMON}==> INSTALLING DOCKER...${NC}"
sudo apt-get update -y
sudo curl -fsSL test.docker.com -o get-docker.sh && sh get-docker.sh
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo -e "${BLUE}$<== DONE INSTALLING DOCKER.${NC}"

echo -e "${LEMON}==> INSTALLING KUBECTL...${NC}"
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl"
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo kubectl version --client
echo -e "${BLUE}$<== DONE INSTALLING KUBECTL.${NC}"

echo -e "${PINK}==> INSTALLING K3D...${NC}"
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo -e "${BLUE}$<== DONE INSTALLING K3D.${NC}"

echo -e "${PINK}==> CREATING K3D CLUSTER...${NC}"
# `-p "8888:30080"`: This flag is used to map ports from the host machine to the Kubernetes cluster.
# It's specified in the format `<host-port>:<container-port>`.
# Here, it's mapping port 8888 on the host machine to port 30080 in the Kubernetes cluster.
# This means that any traffic sent to port 8888 on the host machine will be forwarded to port 30080 within the Kubernetes cluster.
#8888: the port on my local machine where i will access the application
#30080: the port where the actual application is listening
sudo k3d cluster create IoT -p "8888:30080"
sleep 5;
echo -e "${BLUE}<== K3D CLUSTER CREATED.${NC}"

echo -e "${LEMON}==> CREATING ARGOCD NAMESPACE...${NC}"
# This will create a new namespace, argocd, where Argo CD services and application resources will live.
sudo kubectl create namespace argocd
sleep 5;
echo -e "${BLUE}<== ARGOCD NAMESPACE CREATED.${NC}"

echo -e "${LEMON}==> INSTALLING ARGOCD IN THE K3D CLUSTER...${NC}"
# This command apply the yaml file that installs everything that argocd needs.
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# If ArgoCD hasn't completed its setup, the secret might not yet have been created. we have to Ensure that ArgoCD is fully 
# deployed and all its components are running correctly.
# ensure that the environment is fully operational before moving on to the next steps
sudo kubectl wait -n argocd --for=condition=Ready pods --all --timeout=120s
echo -e "${BLUE}==>  ARGOCD INSTALLED IN THE K3D CLUSTER.${NC}"

echo -e "${PINK}==> Getting ArgoCD password...${NC}"
# retrieve the password for the Argo CD admin user.
sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo

# we need actually to apply this configuration to configure ArgoCD with this application logic 
sudo kubectl apply -f /vagrant/deployement/app.yaml

# make the argocd-server service available locally on port 8080 by portforwarding it to acces it
sudo kubectl port-forward --address 0.0.0.0 -n argocd svc/argocd-server 8080:443
# By specifying --address 0.0.0.0, you're allowing external devices (not just localhost) to connect to the forwarded port



echo -e "${CYAN}SETUP COMPLETED.${NC}"