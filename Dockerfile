FROM ghcr.io/codysk/bgmi-all-in-one-base:1.5
MAINTAINER me@iskywind.com

LABEL org.opencontainers.image.source=https://github.com/codysk/bgmi-docker-all-in-one

VOLUME ["/bgmi"]

ENV LANG=C.UTF-8 BGMI_PATH="/bgmi/conf/bgmi"
ADD ./ /home/bgmi-docker

RUN { \
	apk add sudo busybox-suid && \
	pip install /home/bgmi-docker/BGmi && \
	chmod +x /home/bgmi-docker/entrypoint.sh; \
}

EXPOSE 80 9091

ENTRYPOINT ["/home/bgmi-docker/entrypoint.sh"]

