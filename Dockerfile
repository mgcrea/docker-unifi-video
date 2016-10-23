FROM ubuntu:14.04
MAINTAINER Olivier Louvignes <olivier@mgcrea.io>

ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-1.0.0}
ENV UNIFI_USER unifi-video
ENV UNIFI_GROUP unifi-video
ENV UID 1027
ENV GID 106

# Install mongo
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install binutils curl ca-certificates mongodb-org openjdk-7-jre-headless jsvc psmisc sudo lsb-release -y --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean

RUN curl -L -o unifi-video.deb http://dl.ubnt.com/firmwares/unifi-video/${IMAGE_VERSION}/unifi-video_${IMAGE_VERSION}~Ubuntu14.04_amd64.deb \
  && dpkg -i unifi-video.deb

VOLUME ["/var/lib/unifi-video", "/var/log/unifi-video", "/var/run/unifi-video", "/usr/lib/unifi-video/work"]

EXPOSE 7080/tcp 7443/tcp 6666 7445/tcp 7446/tcp 7447

WORKDIR /usr/lib/unifi-video

CMD ["java", "-cp", "/usr/share/java/commons-daemon.jar:/usr/lib/unifi-video/lib/airvision.jar", "-Dav.tempdir=/var/cache/unifi-video", "-Djava.security.egd=file:/dev/./urandom", "-Xmx1024M", "-Djava.library.path=/usr/lib/unifi-video/lib", "-Djava.awt.headless=true", "-Dfile.encoding=UTF-8", "com.ubnt.airvision.Main", "start"]
