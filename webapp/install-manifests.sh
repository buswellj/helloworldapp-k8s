#!/bin/bash

K8SHOST="18.224.40.4"
K8SUSER="ubuntu"

export K8SHOST K8SUSER

scp *.yaml $K8SUSER@$K8SHOST:/tmp
ssh -x -l $K8SUSER $K8SHOST "sudo cp /tmp/handy*.yaml /opt/k8s"

ssh -x -l $K8SUSER $K8SHOST "sudo microk8s kubectl apply -f /opt/k8s/handy-hello-deployment.yaml"
ssh -x -l $K8SUSER $K8SHOST "sudo microk8s kubectl apply -f /opt/k8s/handy-hello-service.yaml"
