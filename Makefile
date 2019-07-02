DOCKER?=docker
VERSION?=dev
TAG?=flimberger/apt-proxy-container:${VERSION}
CACHEVOL?=apt-proxy-cache
LOGVOL?=apt-proxy-logs
PROXYADDR?=127.0.0.1

build:
	${DOCKER} build -t ${TAG} .
.PHONY: build

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
