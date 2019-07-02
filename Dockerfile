FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update &&\
	apt-get install --reinstall -y ca-certificates &&\
	apt-get dist-upgrade -y &&\
	apt-get install -y --no-install-recommends apt-cacher-ng &&\
	apt-get clean &&\
	rm -rf /var/lib/apt/lists/*
CMD ["/usr/sbin/apt-cacher-ng", "-c", "/etc/apt-cacher-ng", "ForeGround=1", "SocketPath=/run/apt-cacher-ng/socket"]
