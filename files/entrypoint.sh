#!/bin/bash

# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# allow user override on docker start
if [[ $UID != "106" ]]; then
  echo "Setting up user..."
  usermod -u $UID $UNIFI_USER
fi
if [[ $GID != "107" ]]; then
  echo "Setting up group..."
  usermod -g $GID $UNIFI_GROUP
fi

# initialize
if [[ ! -f /var/lib/unifi-video/system.properties ]]; then
  echo "Intializing system.properties..."
  cp /usr/lib/unifi-video/etc/system.properties /var/lib/unifi-video/system.properties
  mkdir /var/lib/unifi-video/logs
  echo "Setting up permissions..."
  chown -R $UNIFI_USER:$UNIFI_GROUP /var/lib/unifi-video /var/log/unifi-video /usr/lib/unifi-video/work
fi

echo "Starting unifi-video..."
/usr/sbin/unifi-video start --verbose --nodetach
# /usr/bin/jsvc -cwd $UNIFI_WORKDIR -nodetach -user $UNIFI_USER -home $JAVA_HOME -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar -pidfile /var/run/unifi-video/unifi-video.pid -procname unifi-video -Dav.tempdir=/var/cache/unifi-video -Djava.security.egd=file:/dev/./urandom -Xmx927M -Djava.library.path=/usr/lib/unifi-video/lib -Djava.awt.headless=true -Djavax.net.ssl.trustStore=/usr/lib/unifi-video/data/ufv-truststore -Dfile.encoding=UTF-8 com.ubnt.airvision.Main start
