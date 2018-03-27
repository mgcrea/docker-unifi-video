# mgcrea/unifi-video [![Docker Pulls](https://img.shields.io/docker/pulls/mgcrea/unifi-video.svg)](https://registry.hub.docker.com/u/mgcrea/unifi-video/)  [![Docker Latest](https://img.shields.io/badge/latest-v3.5.1-blue.svg)](https://hub.docker.com/r/mgcrea/unifi-video/tags/)

Docker image for Ubiquiti [Unifi Video Controller](https://www.ubnt.com/unifi-video/unifi-nvr/)


## Install

```sh
docker pull mgcrea/unifi-video:3
```


## Quickstart

Use [docker-compose](https://docs.docker.com/compose/) to start the service

```sh
docker-compose up -d
```


### Compose

```yaml
version: '3.1'
services:
  unifi_video_controller:
    image: mgcrea/unifi-video:3
    hostname: unifi_video
    container_name: unifi_video
    environment:
      - TZ=Europe/Paris
    network_mode: "bridge"
    privileged: true # @TODO SYS_ADMIN, DAC_READ_SEARCH, NET_BIND_SERVICE, SYS_PTRACE, SETUID, and SETGID
    volumes:
      - ./data/lib:/var/lib/unifi-video
      - ./data/log:/var/log/unifi-video
      - ./data/work:/usr/lib/unifi-video/work
      - ./data/cache:/var/cache/unifi-video
    ports:
      - "7080:7080/tcp"
      - "7443:7443/tcp"
      - "6666:6666"
      - "7440:7440"
      - "7445:7442"
      - "7445:7443"
      - "7445:7445"
      - "7446:7446"
      - "7447:7447"
    restart: always

```


## Debug

Create and inspect a new instance

```sh
docker-compose run unifi_video_controller /bin/bash
```

Inspect a running instance

```sh
docker exec -it unifi_video_controller script -q -c "TERM=xterm /bin/bash" /dev/null;
```
