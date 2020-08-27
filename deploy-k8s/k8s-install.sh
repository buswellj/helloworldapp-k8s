#!/bin/bash

INV_TGT_HOST="18.224.40.4"
INV_TGT_USER="ubuntu"

export INV_TGT_HOST INV_TGT_USER

echo "k8s installation script"
echo ""

echo " [*] Starting Installation...."
echo " [-] Setting hostname"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo hostnamectl set-hostname hellohandy.plural.cloud"
echo " [-] Updating Operating System (this may take a few minutes)"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo apt-get update -y && sudo apt-get upgrade -y"
echo " [-] Installing git, screen and net-tools"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo apt-get install git -y && sudo apt-get install screen -y && sudo apt-get install net-tools -y"
echo " [-] Installing Lynx, Unzip, GPG and jq"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo apt-get install lynx -y && sudo apt-get install unzip -y && sudo apt-get install gpg -y && sudo apt-get install jq -y"
echo " [-] Adding k8s user"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo adduser --disabled-password --gecos \"\" ipk8s"
echo " [-] Adding k8s user to sudo group"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo usermod -aG sudo ipk8s"
echo " [-] Installing microk8s"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo snap install microk8s --classic --channel=1.18/stable"
echo " [-] Reboot the system"
ssh -x -l $INV_TGT_USER $INV_TGT_HOST "sudo shutdown -r +2"
echo ""

echo "System will reboot in about 2 minutes, please give the system an addition 2-3 minutes to boot"
echo ""
echo ""

