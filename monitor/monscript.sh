#!/bin/bash

curl -v https://hellohandy.plural.cloud/health -D /tmp/appcheck
MONRESULT=`cat /tmp/appcheck | grep '200 OK'`
export MONRESULT

RTIME=`cat /tmp/appcheck | grep X-Response-Time | cut -f 2 -d \:`
export RTIME

RNOW=`date +%s`
export RNOW

echo $RNOW $RTIME >> /tmp/responsetimes

echo $MONRESULT

if [ -z "$MONRESULT" ]
then
 AWSMESSAGE=$(echo "hellohandy.plural.cloud health check failure ")
 AWSSLACKMSG="curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"aws-iam-key-policy: ${AWSMESSAGE} \"}' https://hooks.slack.com/services/XXXXXXXX/CCCCCCCCCC/dahhdsfkjhdwfkjh23897525"
 echo $AWSSLACKMSG >> /tmp/send2slack.sh
 chmod 755 /tmp/send2slack.sh
 /tmp/send2slack.sh
 rm -rf /tmp/send2slack.sh
fi

rm -rf /tmp/appcheck
