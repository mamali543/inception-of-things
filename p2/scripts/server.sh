#!/bin/bash

# Update system and install dependencies
sudo apt-get update -qq
sudo apt-get install -qq -y curl net-tools

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh 2>&1 >/dev/null
sudo usermod -aG docker vagrant

# Install K3s
SERVER_IP="192.168.56.110"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip ${SERVER_IP}  --bind-address=${SERVER_IP} --flannel-iface=eth1 --write-kubeconfig-mode 644" sh -

# Wait for K3s to be up
sleep 30

# Deploy application to K3s
kubectl apply -f /vagrant/kubernetes/deployment.yaml
kubectl apply -f /vagrant/kubernetes/service.yaml
kubectl apply -f /vagrant/kubernetes/ingress.yaml
sleep 30

echo "Waiting for pod to be ready..."
for app in app-one app-two app-three; do
  POD_NAME=$(kubectl get pods -l app=$app -o jsonpath="{.items[0].metadata.name}")
  kubectl cp /vagrant/kubernetes/${app}.html default/$POD_NAME:/usr/share/nginx/html/index.html
done

echo "Deployment and service setup completed, and app1.html copied."