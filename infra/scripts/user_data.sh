  user_data = <<-EOF
    #!/bin/bash
    set -e
    
    exec > >(tee -a /var/log/user-data.log) 2>&1
    echo "Starting server provisioning at $(date)"
    
    wait_for_apt() {
      while fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || fuser /var/lib/dpkg/lock >/dev/null 2>&1 || fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
        echo "Waiting for apt locks..."
        sleep 5
      done
    }
    
    echo "Updating system packages..."
    wait_for_apt
    apt-get update -y
    apt-get upgrade -y
    
    echo "Applying security hardening..."
    sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd
    
    echo "Setting up swap space..."
    if [ ! -f /swapfile ]; then
      fallocate -l 1G /swapfile
      chmod 600 /swapfile
      mkswap /swapfile
      swapon /swapfile
      echo '/swapfile none swap sw 0 0' >> /etc/fstab
    fi
    
    echo "Configuring firewall..."
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw --force enable
    
    echo "Server provisioning completed at $(date)"
  EOF
}