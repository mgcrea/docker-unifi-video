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
  && apt-get install apt-transport-https binutils curl ca-certificates jsvc psmisc sudo lsb-release tzdata -y --no-install-recommends

# Install mongo 3.4
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv BC711F9BA15703C6

# Install java 8
# RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list \
#   && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EEA14886

# Install java8
# RUN add-apt-repository ppa:webupd8team/java \
#  && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections

RUN apt-get update \
  #   && apt-get install oracle-java8-installer -y --no-install-recommends \
  && apt-get install openjdk-8-jre-headless -y --no-install-recommends \
  && apt-get install mongodb-org -y --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean

RUN curl -L -o unifi-video.deb https://dl.ubnt.com/firmwares/ufv/v${IMAGE_VERSION}/unifi-video.Ubuntu16.04_amd64.v${IMAGE_VERSION}.deb \
  && dpkg -i unifi-video.deb

VOLUME ["/var/lib/unifi-video", "/var/log/unifi-video", "/var/run/unifi-video", "/usr/lib/unifi-video/work"]

EXPOSE 7080/tcp 7443/tcp 6666 7440 7442 7445 7446 7447

WORKDIR $UNIFI_WORKDIR

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
# ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN sed -i -e 's/ENABLE_TMPFS=yes/ENABLE_TMPFS=no/' -e 's/log_error()/ulimit() {\n\techo ""\n}\n\nlog_error()/' /usr/sbin/unifi-video

ADD ./files/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 770 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
