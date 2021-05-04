FROM ghcr.io/codysk/bgmi-all-in-one-base:1.1  AS test-env
MAINTAINER me@iskywind.com

ENV LANG=C.UTF-8 BGMI_PATH="/bgmi/conf/bgmi"
ADD ./ /home/bgmi-docker

RUN { \
	pip install pytest-cov; \
	cd /home/bgmi-docker/BGmi; \
	pytest --cov=bgmi tests; \
	pip install /home/bgmi-docker/BGmi; \
}


FROM ghcr.io/codysk/bgmi-all-in-one-base:1.1
MAINTAINER me@iskywind.com

VOLUME ["/bgmi"]

ENV LANG=C.UTF-8 BGMI_PATH="/bgmi/conf/bgmi"
ADD ./ /home/bgmi-docker

RUN { \
	pip install /home/bgmi-docker/BGmi; \
	chmod +x /home/bgmi-docker/entrypoint.sh; \
}

EXPOSE 80 9091

ENTRYPOINT ["/home/bgmi-docker/entrypoint.sh"]

