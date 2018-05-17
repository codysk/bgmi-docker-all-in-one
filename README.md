# BGmi-docker-all-in-one

[![Build Status](https://travis-ci.org/codysk/bgmi-docker-all-in-one.svg?branch=master)](https://travis-ci.org/codysk/bgmi-docker-all-in-one)

a BGmi service with transmission via https://github.com/BGmi/BGmi
## Prerequisites

a docker service with linux container

## Installing

pull the mainline build from docker hub

```
docker pull codysk/bgmi-all-in-one
```

or build it from source

```
git clone --recurse-submodules https://github.com/codysk/bgmi-docker-all-in-one.git
cd bgmi-docker-all-in-one
docker build ./ -t="codysk/bgmi-all-in-one"
```

then launch on docker

```
docker run -p 80:80 -p 9091:9091 codysk/bgmi-all-in-one
```

here is a few envirmonment variables to init the bgmi service

* BGMI_SOURCE - set bgmi default data source (bangumi_moe, mikan_project or dmhy)
* BGMI_ADMIN_TOKEN - set bgmi web interface auth token (default token will be `bgmi_token` when this variable is not set or empty)

all data volumn and configurable directory/file mount at `/bgmi`
you can mount it at host filesystem if your want

example:
```
docker run -v /home/codysk/bgmi:/bgmi -p 80:80 -p 9091:9091 -e BGMI_SOURCE=dmhy -e BGMI_ADMIN_TOKEN=admin codysk/bgmi-all-in-one
```

## Usage:

### command line interface

bgmi service is running at docker container so you must get in the container if you want use bgmi command.

get the container id:
```
docker ps
```

and get in the container:
```
docker exec -it <BGMI-CONTAINER-ID> /bin/bash
```

now you have the shell in the container
more command see [BGmi official repo](https://github.com/BGmi/BGmi)

### web interface

bgmi webui is running at port 80/tcp, tranmission webui at 9091/tcp

### other message

Transmission is running in the docker container which behind docker bridge network by default setting.
Docker network will NATs the container's traffic. But docker bridge not support the auto-portforwarding protocol like NAT-PMP(uPNP).
So transmission cannot forwarding the port(s) for peer to peer connection.

Solutions:
	- Use `-p 51413:51413/tcp -p 51413:51413/udp` expose transmission port on host, then statically forward these ports to the host from your router.
	- Use `--net=host` so docker will not running the container at docker network, the container will listen on the host's network interface directly.(Recommand, but only works on Linux hosts)
	- Teach docker how to handle uPNP (very hard)

