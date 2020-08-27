# helloworldapp-k8s

The process:

1. Created the webapp and tested it locally
2. Created terraform to create the instance and security groups
3. Deployed the k8s-install.sh script to install k8s on the instance
4. Deployed the k8s-setup.sh script to finish the k8s configuration
5. Locally built and pushed the docker image to the k8s registry
6. Used the install-manifests.sh script to install the webapp
7. Tested the local webapp in the browser
8. Setup dns as hellohandy.plural.cloud to make it easier to access (TF via Linode)
9. Established ssh tunnels to access the dashboard and cluster via Lens

The config for pushing to the private insecure registry are in
docker-local/daemon.json and a script required after the config is updated locally.

Docker build command to generate the appropriate tags:

```
docker build . -t 18.224.40.4:32000/handy-hello:registry
Sending build context to Docker daemon  2.123MB
Step 1/7 : FROM node:10.22.0-alpine
 ---> 8e473595b853
Step 2/7 : WORKDIR /app
 ---> Using cache
 ---> 15e37b91c434
Step 3/7 : COPY package.json /app
 ---> Using cache
 ---> 5568ff032948
Step 4/7 : RUN npm install
 ---> Using cache
 ---> 75a77f101450
Step 5/7 : COPY . /app
 ---> Using cache
 ---> 5c07c23f3ab0
Step 6/7 : CMD node index.js
 ---> Using cache
 ---> fb0193904af8
Step 7/7 : EXPOSE 8666
 ---> Using cache
 ---> 3aa708c2273b
Successfully built 3aa708c2273b
Successfully tagged 18.224.40.4:32000/handy-hello:registry
```

Docker push command to send it to the registry:
```
docker push 18.224.40.4:32000/handy-hello
The push refers to repository [18.224.40.4:32000/handy-hello]
a7bfc177bbc4: Pushed
ee304979d47b: Pushed
beb827820fc5: Pushed
12589011a1f8: Pushed
3780f321c373: Pushed
789d258c5696: Pushed
9c733f70df77: Pushed
3e207b409db3: Pushed
registry: digest: sha256:55a216e73a65921e4f304078e57fb2060d51cfe5a05e0ae39d337d28dee22005 size: 1993
```

##webapp

The web application is stored in webapp/handy-hello/

The application is written in Javascript using Node.JS and
Express.JS. It supports the following endpoints:

| Endpoint | Description |
| -------- | ----------- |
| / | Displays Hello World |
| /<name>/hello | Where <name> is a name, display Hello name|
| /hello/<name> | Does the same as the above endpoint |
| /version | Displays app version |
| /health | health check endpoint |
| /dumplog | dumps access logs for app |

The app listens on port 8666 and uses morgan to output logs.
The server listen command is forced to IPv4.

There are some support scripts in the webapp directory:

| Script | Description |
| ------ | ----------- |
| docker-local-test.sh | Script to test webapp locally with Docker|
| install-manifests.sh | Installs the manifests for the app on k8s |
| lens-getcfg.sh | Retrieves the configuration for Lens add cluster |

The deployment manifest is in handy-hello-deployment.yaml, it uses
a best-effort QoS, three replicas and pulls the container from the
local registry. It uses a livenessProbe for health checking to the
/health endpoint.

The service manifest is in handy-hello-service.yaml, it uses NodePort
to make the pod accessible on port 32359, which is then used by the
Caddy web server to proxy into. This protects the service behind the
Caddy web server, while being able to balance across the replicas.

The ssh-tunnel.txt contains the ssh commands to tunnel to the k8s
instance and make the dashboard and API (16443) ports accessible to
your local machine. The dashboard token command and current token is
in file dashboard-token for your convenience.

## terraform

The terraform code is in terraform/handy-k8s, it contains:

aws.tf - aws provider

ec2k8s.tf - instance config

outputs.tf - public ip

secgroups.tf - security groups that control access to the instance ports

sshkey.tf - the ssh key config for the instance

terraform.tfvars - terraform variables

variables.tf - variables used in the terraform code


## k8s deployment

deploy-k8s directory contains the config for Caddy and the installation and
setup quick scripts for k8s. These install k8s and update the OS on the Ubuntu
20.04 AMI. note: I would use Packer to generate a new AMI in a real environment,
to save time, I used this script

The scripts are executed k8s-install.sh, then k8s-setup.sh

## extra scripts

There are some helper scripts in scripts/ these include

awsip.sh - obtain the aws instance IP (execute from the terraform directory)

awssh.sh - ssh to the aws instance

genkey.sh - quick script to generate an ssh key

secure-genkey.sh - script to generate the ssh key I would use in a live env

test-aws-credentials.sh - script to check aws credentials work


