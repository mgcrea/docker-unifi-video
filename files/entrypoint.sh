#!/bin/bash
# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# allow user override on docker start
echo "Setting up user..."
usermod -u $UID $UNIFI_USER
usermod -g $GID $UNIFI_GROUP

# set permissions so that we have access to volumes
echo "Setting up permissions..."
chown -R $UNIFI_USER:$UNIFI_GROUP /var/lib/unifi-video /var/log/unifi-video /usr/lib/unifi-video/work

echo "Starting unifi-video..."
/usr/bin/jsvc -cwd $UNIFI_WORKDIR -nodetach -user $UNIFI_USER -home /usr/lib/jvm/java-8-openjdk-amd64 -cp /usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar -pidfile /var/run/unifi-video/unifi-video.pid -procname unifi-video -Dav.tempdir=/var/cache/unifi-video -Djava.security.egd=file:/dev/./urandom -Xmx927M -Djava.library.path=/usr/lib/unifi-video/lib -Djava.awt.headless=true -Djavax.net.ssl.trustStore=/usr/lib/unifi-video/data/ufv-truststore -Dfile.encoding=UTF-8 com.ubnt.airvision.Main start
