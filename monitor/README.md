## monitoring

Real-time health checking of the application with an interface into
slack is provided with the script in this directory.

The webapp provides a X-Response-Time, that the script captures and
stores along with the unix timestamp. The script also has the
capability of pushing into a slack webhook.

When doing initial monitoring, I would run this script on a
management system to look for problems, probably would setup a
dedicated slack channel. I would also use the response time
data to look for potential issues before they occur over time
by writing a script to examine the data captured by the monitoring
script.

In production, I would migrate the script over to prometheus before
it went into production.

The manifest for the web application uses liveness probes to determine
the health, so there is some degree of automation there along with the
replicas.

I would examine the application ("monitor it") using Lens, Grafana and
the k8s dashboard to periodically check on its behavior and tweak the
manifest settings as needed.

I would probably look into doing canary deployments for future versions
as the application was developed further.


