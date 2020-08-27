## Summary

As this is a simple web application, I opted for the Express.JS
framework as its lightweight, working applications can be brought
up quickly, it supports packages.json for easy assembly and is
very simple to build into a container using Docker. There are a
wide range of add-on capabilities via npm, such as morgan for
logging and responseTime for useful metrics. I added support
for logging and being able to dump the logs via HTTP API to
make it easier to debug/develop. The responseTime metrics I
felt were a good addition as they could be used to leverage
better monitoring, improve performance and provide a baseline for
performance issues as the code base is expanded.

I chose alpine for the docker image as it is very lightweight but
retains enough utilities that you can debug it by logging into
the container's shell via Lens or via the shell. This results in
a much smaller docker image.

I went with terraform for infrastructure as code as terraform's
AWS provider is well supported. If I was deploying this into
production I would have used TFE to maintain state, if TFE was
unavailable, I would deploy an EC2 instance with consul and
deploy atlantis with GitHub integration.

I opted to use security groups to restrict access to ports via
AWS rather than local firewall rules on the instance.

https://github.com/runatlantis/atlantis

Here is an example of the consul terraform backend I would use:

```
terraform {
  backend "consul" {
    address  = "consul.mydomain.net:8500"
    scheme   = "http"
    path     = "tf_atlantis/terraform.tfstate"
    lock     = true
    gzip     = false
  }
}
```

To save time, I opted to do local state and local sshkeys.

The code could easily be fleshed out further to support IAM, Cloudwatch,
if it was going into production.

I decided to use the Caddy web server as it is a next-generation web server,
has nginx comparable performance and performs automated management for TLS.
It is a HTTPS / Security first focused web server.

I could have used Packer and generated new Ubuntu 20.04 AMIs, which is what
I would do in production, however to save time, I wrote some quick scripts that
executed the commands via ssh, these install microk8s after updating the Ubuntu
system.

I decided to go with microk8s as it runs in a small instance (<= 8GB), while
providing a full k8s experience. So it was a good option to quickly get operational.
It also enabled a local registry, which using the security groups to limit access
to my IP via the mgmt_ip variable, I was able to push the web app locally from my
local system without needing to configure VPN etc. In production or a live env, I
would have setup a secure registry via HTTPS. I could have probably configured
Caddy to reverse proxy the local docker registry if time wasn't a factor. This also
enabled the possibility of using ssh tunneling to access the cluster securely via
the dashboard and Lens.

I seperated the service and deployment in kubernetes so that I could test the
application before making it live behind Caddy.

I wrote a quick monitoring script as for a new application like this, I would
start the monitoring process by examining how k8s performs managing the application,
while reviewing the response time and log data, and use slack to determine the
necessary thresholds of alerting before sending it to pagerduty. The monitoring script
checks the /health path in the webapp. To make it work with your slack, you would need
to change the webhook URL to match your environment. I would also monitor using Lens
and the dashboard.

If you would like to gain access to the deployment, the zip file includes the homedir
of the user I created to build this, so the private key is there along with the TF
state. If you have problems, let email me your source IP or subnet, and I will add it
to the mgmt IP.




