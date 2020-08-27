#!/bin/bash

# use ed25519 in real prod environment

ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "buswellj@gmail.com"
