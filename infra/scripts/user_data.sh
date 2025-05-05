#!/bin/bash
set -e

exec > >(tee -a /var/log/user-data.log) 2>&1
echo "Starting server provisioning at $(date)"

# APT kilidini bekleme fonksiyonu
wait_for_apt() {
  while fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
    echo "Waiting for apt locks..."
    sleep 5
  done
}

# Sistem güncellemeleri
echo "Updating system packages..."
wait_for_apt
apt-get update -y
apt-get upgrade -y

# Docker kurulumu
echo "Installing Docker..."
wait_for_apt
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker'ı sudo'suz kullanmak için kullanıcıyı gruba ekle
usermod -aG docker root

echo "Server provisioning completed at $(date)"