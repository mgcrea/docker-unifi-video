# mgcrea/unifi-video [![Docker Pulls](https://img.shields.io/docker/pulls/mgcrea/unifi-video.svg)](https://registry.hub.docker.com/u/mgcrea/unifi-video/)  [![Docker Latest](https://img.shields.io/badge/latest-v3.4.0-blue.svg)](https://hub.docker.com/r/mgcrea/unifi-video/tags/)

Docker image for Ubiquiti [Unifi Controller](https://www.ubnt.com/enterprise/software/)


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
version: '2'
services:
  unifi_video_controller:
    image: mgcrea/unifi-video:3
    container_name: unifi_video_controller
    environment:
      - TZ=Europe/Paris
    network_mode: "bridge"
    privileged: true
    volumes:
      - ./data/lib:/var/lib/unifi-video
      - ./data/log:/var/log/unifi-video
      - ./data/work:/usr/lib/unifi-video/work
    ports:
      - "8080:8080/tcp"
      - "8443:8443/tcp"
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
