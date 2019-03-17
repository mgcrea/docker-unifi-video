DOCKER_IMAGE := mgcrea/unifi-video
IMAGE_VERSION := 3.10.1
BASE_IMAGE := ubuntu:16.04

all: build

bash:
	@docker run --entrypoint /bin/bash --privileged --rm -it ${DOCKER_IMAGE}:latest

build:
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:latest .

base:
	@docker pull ${BASE_IMAGE}

rebuild: base
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:latest .

release: rebuild
	@docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} --tag=${DOCKER_IMAGE}:${IMAGE_VERSION} .
	@scripts/tag.sh ${DOCKER_IMAGE} ${IMAGE_VERSION}

push:
	@scripts/push.sh ${DOCKER_IMAGE} ${IMAGE_VERSION}
