FROM alpine:3.22 AS wheels-builder
# rpds-py (dependency of mcp -> jsonschema) ships no arm musl wheels;
# build one with a rust toolchain new enough for edition2024 crates
RUN apk add --update rust cargo python3 py3-pip && \
	python3 -m venv /wheelbuilder && \
	/wheelbuilder/bin/pip wheel rpds-py -w /wheelhouse-extra

FROM ghcr.io/codysk/bgmi-all-in-one-base:1.7
MAINTAINER me@iskywind.com

LABEL org.opencontainers.image.source=https://github.com/codysk/bgmi-docker-all-in-one

VOLUME ["/bgmi"]

ENV LANG=C.UTF-8 BGMI_PATH="/bgmi/conf/bgmi"
ADD ./ /home/bgmi-docker

COPY --from=wheels-builder /wheelhouse-extra /wheelhouse-extra

RUN { \
	apk add sudo busybox-suid && \
	python -m venv /home/bgmi-docker/.venv && \
	source /home/bgmi-docker/.venv/bin/activate && \
	PIP_FIND_LINKS="/wheelhouse /wheelhouse-extra" pip install --prefer-binary /home/bgmi-docker/BGmi && \
	chmod +x /home/bgmi-docker/entrypoint.sh; \
}

ENV PATH="/home/bgmi-docker/.venv/bin:$PATH"

EXPOSE 80 9091

ENTRYPOINT ["/home/bgmi-docker/entrypoint.sh"]
