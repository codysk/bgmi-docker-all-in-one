FROM ghcr.io/codysk/bgmi-all-in-one-base:1.7
MAINTAINER me@iskywind.com

LABEL org.opencontainers.image.source=https://github.com/codysk/bgmi-docker-all-in-one

VOLUME ["/bgmi"]

ENV LANG=C.UTF-8 BGMI_PATH="/bgmi/conf/bgmi"
ADD ./ /home/bgmi-docker

RUN { \
	apk add sudo busybox-suid && \
	pip -m venv /home/bgmi-docker/.venv && \
	source /home/bgmi-docker/.venv/bin/activate && \
	pip install /home/bgmi-docker/BGmi && \
	chmod +x /home/bgmi-docker/entrypoint.sh; \
}

ENV PATH="/home/bgmi-docker/.venv/bin:$PATH"

EXPOSE 80 9091

ENTRYPOINT ["/home/bgmi-docker/entrypoint.sh"]

