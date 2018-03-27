FROM ubuntu:16.04
MAINTAINER Olivier Louvignes <olivier@mgcrea.io>

ARG IMAGE_VERSION
ENV IMAGE_VERSION ${IMAGE_VERSION:-1.0.0}
ENV UNIFI_USER unifi-video
ENV UNIFI_GROUP unifi-video
ENV UNIFI_WORKDIR /usr/lib/unifi-video
ENV UID 106
ENV GID 107

RUN apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install apt-transport-https binutils curl ca-certificates jsvc psmisc sudo lsb-release -y --no-install-recommends

# Install mongo
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv BC711F9BA15703C6

RUN apt-get update \
  && apt-get install mongodb-org openjdk-8-jre-headless -y --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean
 
RUN curl -L -o unifi-video.deb https://dl.ubnt.com/firmwares/ufv/v${IMAGE_VERSION}/unifi-video.Ubuntu16.04_amd64.v${IMAGE_VERSION}.deb \
  && dpkg -i unifi-video.deb

VOLUME ["/var/lib/unifi-video", "/var/log/unifi-video", "/var/run/unifi-video", "/usr/lib/unifi-video/work"]

EXPOSE 7080/tcp 7443/tcp 6666 7445/tcp 7446/tcp 7447

WORKDIR $UNIFI_WORKDIR

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN sed -i -e 's/UFV_DAEMONIZE=true/UFV_DAEMONIZE=false/' -e 's/log_error()/ulimit() {\n\techo ""\n}\n\nlog_error()/' /usr/sbin/unifi-video 

ADD ./files/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 770 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]


