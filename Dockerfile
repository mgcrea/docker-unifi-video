FROM ubuntu:16.04
MAINTAINER Olivier Louvignes <olivier@mgcrea.io>

ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-1.0.0}
ENV UNIFI_USER unifi-video
ENV UNIFI_GROUP unifi-video
ENV UID 106
ENV GID 107

# Install mongo
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install binutils curl ca-certificates mongodb-org openjdk-8-jre-headless jsvc psmisc sudo lsb-release -y --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean

RUN curl -L -o unifi-video.deb https://dl.ubnt.com/firmwares/unifi-video/${IMAGE_VERSION}/unifi-video_${IMAGE_VERSION}-Ubuntu16.04_amd64.deb \
  && dpkg -i unifi-video.deb

VOLUME ["/var/lib/unifi-video", "/var/log/unifi-video", "/var/run/unifi-video", "/usr/lib/unifi-video/work"]

EXPOSE 7080/tcp 7443/tcp 6666 7445/tcp 7446/tcp 7447

WORKDIR /usr/lib/unifi-video

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
CMD ["/usr/bin/jsvc", "-cwd", "/usr/lib/unifi-video", "-nodetach", "-user", "unifi-video", "-home", "/usr/lib/jvm/java-8-openjdk-amd64", "-cp", "/usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar", "-pidfile", "/var/run/unifi-video/unifi-video.pid", "-procname", "unifi-video", "-Dav.tempdir=/var/cache/unifi-video", "-Djava.security.egd=file:/dev/./urandom", "-Xmx927M", "-Djava.library.path=/usr/lib/unifi-video/lib", "-Djava.awt.headless=true", "-Djavax.net.ssl.trustStore=/usr/lib/unifi-video/data/ufv-truststore", "-Dfile.encoding=UTF-8", "com.ubnt.airvision.Main", "start"]