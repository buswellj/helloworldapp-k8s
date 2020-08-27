#!/bin/bash

cd ./handy-hello
docker build -t handy-hello .
sleep 1s
docker image ls
docker run --publish 8266:8666 --detach --name hh handy-hello:latest
sleep 5s
docker ps
sleep 2s
sudo netstat -nap | grep 8266 

cd ../

