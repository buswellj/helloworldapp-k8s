#!/bin/bash

#
# This script gets the config to add a cluster in Lens
#

ssh ubuntu@18.224.40.4 "sudo microk8s.kubectl config view --minify --raw"

