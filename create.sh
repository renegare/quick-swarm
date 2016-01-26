#!/usr/bin/env bash

SWARM_NAME=dev
SWARM_SIZE=3

docker-machine create -d virtualbox swarm-token
eval "$(docker-machine env swarm-token)"
SWARM_TOKEN=`docker run swarm create 2>/dev/null`

echo $SWARM_NAME swarm token will be \"$SWARM_TOKEN\"
docker-machine rm -f swarm-token

docker-machine create -d virtualbox --swarm --swarm-master \
  --swarm-discovery token://$SWARM_TOKEN $SWARM_NAME-swarm-master

# put in a loop
docker-machine create -d virtualbox --swarm \
  --swarm-discovery token://$SWARM_TOKEN $SWARM_NAME-swarm-agent-01
docker-machine create -d virtualbox --swarm \
  --swarm-discovery token://$SWARM_TOKEN $SWARM_NAME-swarm-agent-02

docker-machine ls

sleep 10

eval "$(docker-machine env --swarm $SWARM_NAME-swarm-master)"
