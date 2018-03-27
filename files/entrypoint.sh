#!/bin/bash

# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# allow user override on docker start
if [[ $UID != "106" ]]; then
  usermod -u $UID $UNIFI_USER
fi
if [[ $GID != "107" ]]; then
  usermod -g $GID $UNIFI_GROUP
fi

# set permissions so that we have access to volumes
DOCKER_CHOWN_VOLUMES=${DOCKER_CHOWN_VOLUMES:-"no"}
if [[ $DOCKER_CHOWN_VOLUMES == "yes" ]]; then
  echo "Setting up permissions..."
  chown -R $UNIFI_USER:$UNIFI_GROUP /var/lib/unifi-video /var/log/unifi-video /usr/lib/unifi-video/work /var/cache/unifi-video
fi

echo "Starting unifi-video..."
/usr/sbin/unifi-video start
