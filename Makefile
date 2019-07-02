DOCKER?=docker
CONTAINER?=apt-proxy
TAG?=0.1
HUBUSER?=flimberger
CACHEVOL?=apt-proxy-cache
LOGVOL?=apt-proxy-logs
PROXYADDR?=127.0.0.1

REPO=${HUBUSER}/${CONTAINER}

build:
	${DOCKER} build -t ${CONTAINER}:${TAG} .
.PHONY: build

upload:
	${DOCKER} tag ${CONTAINER}:${TAG} ${REPO}:${TAG}
	${DOCKER} tag ${REPO}:${TAG} ${REPO}:latest
	${DOCKER} push ${REPO}:${TAG}
	${DOCKER} push ${REPO}:latest
.PHONY: upload

shell:
	${DOCKER} run\
		--mount "src=${CACHEVOL},dst=/var/cache/apt-cacher-ng"\
		--mount "src=${LOGVOL},dst=/var/log/apt-cacher-ng"\
		-it -v "${PWD}:/docker"\
		${TAG} /bin/bash
.PHONY: shell

start:
	${DOCKER} run\
		--mount "src=${CACHEVOL},dst=/var/cache/apt-cacher-ng"\
		--mount "src=${LOGVOL},dst=/var/log/apt-cacher-ng"\
		-d -p 3142:3142 ${TAG}
.PHONY: start

createvols:
	${DOCKER} volume create ${CACHEVOL}
	${DOCKER} volume create ${LOGVOL}
.PHONY: createvols

installconfig:
	sed 's,PROXYADDR,${PROXYADDR},' <apt.conf.d/02cache-proxy >/etc/apt/apt.conf.d/02cache-proxy
.PHONY: installconfig
