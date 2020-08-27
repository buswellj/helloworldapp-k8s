#!/bin/bash

INV_TGT_HOST="18.224.40.4"
INV_TGT_USER="ubuntu"

export INV_TGT_HOST INV_TGT_USER

echo "k8s setup script"
echo "Cluster: " $INV_TGT_HOST
echo ""

echo " [*] Starting Setup...."
echo " [-] Enabling k8s DNS"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo /snap/bin/microk8s.enable dns"
echo " [-] Enabling k8s Prometheus"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo /snap/bin/microk8s.enable prometheus"
echo " [-] Enabling k8s Metrics"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo /snap/bin/microk8s.enable metrics-server"
echo " [-] Enabling k8s Storage"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo /snap/bin/microk8s.enable storage"
echo " [-] Enabling k8s Helm3"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo /snap/bin/microk8s.enable helm3"
echo " [-] Enabling k8s registry"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo /snap/bin/microk8s.enable registry"

echo " [-] Setting up Docker Engine | Installing Docker"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo apt -y install docker.io"
echo " [-] Create directories..."
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "mkdir -p /opt/k8s/pce/"
echo " [-] k8s PCE | Fetching HTTPS Core Engine"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "wget https://github.com/caddyserver/caddy/releases/download/v2.1.0/caddy_2.1.0_linux_amd64.tar.gz -O /opt/k8s/pce/caddy.tar.gz"
echo " [-] k8s PCE | Installing HTTPS Core Engine"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "cd /opt/k8s/pce && tar xvf caddy.tar.gz"
echo " [-] k8s PCE | Setting Permissions on HTTPS Core Engine"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "chown 0:0 /opt/k8s/pce/caddy"
echo " [-] k8s PCE | Clean up "
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "rm -rf /opt/k8s/pce/*.gz"
echo " [-] k8s PCE | Creating group"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "groupadd --system caddy"
echo " [-] k8s PCE | Creating system user"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "useradd --system --gid caddy --create-home --home-dir /var/lib/caddy --shell /usr/sbin/nologin --comment \"Caddy web server \" caddy"
echo " [-] k8s PCE | Installing service configuration"
scp caddy.service $INV_TGT_USER@$INV_TGT_HOST:/etc/systemd/system/
echo " [-] k8s PCE | Reloading services"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "systemctl daemon-reload"
echo " [-] k8s PCE | Enabling HTTPS Core Engine"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "systemctl enable caddy"
echo " [-] k8s PCE | Creating configuration directories"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "mkdir -p /etc/caddy"
echo " [-] k8s PCE | Creating logging directories"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "mkdir -p /opt/k8s/pce-logs"
cho " [-] k8s PCE | Applying caddy permissions to logging"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "chown -R caddy.caddy /opt/k8s/pce-logs/"
echo " [-] k8s PCE | Generating HTTPS Core Engine Config"
scp Caddyfile $INV_TGT_USER@$INV_TGT_HOST:/etc/caddy/
echo " [-] k8s PCE | Starting HTTPS Core Engine"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "systemctl start caddy"

