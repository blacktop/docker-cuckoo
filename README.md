![cuckoo-logo](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/logo.png) Dockerfile-beta
======================================================================================================

[![CircleCI](https://circleci.com/gh/blacktop/docker-cuckoo.png?style=shield)](https://circleci.com/gh/blacktop/docker-cuckoo) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/cuckoo.svg)](https://hub.docker.com/r/blacktop/cuckoo/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/cuckoo.svg)](https://hub.docker.com/r/blacktop/cuckoo/) [![Docker Image](https://img.shields.io/badge/docker image-295.7 MB-blue.svg)](https://hub.docker.com/r/blacktop/cuckoo/)

This repository contains a **Dockerfile** of [Cuckoo Sandbox](http://www.cuckoosandbox.org/).

> :construction: WARNING: Currently only works with remote machinery: **esx, vsphere and xenserver**.

**Table of Contents**

-	[cuckoo Dockerfile](#-dockerfile)
	-	[Dependencies](#dependencies)
	-	[Image Tags](#image-tags)
	-	[Installation](#installation)
	-	[To Run on OSX](#to-run-on-osx)
	-	[Getting Started](#getting-started)
	-	[Documentation](#documentation)
		-	[Usage](#usage)
		-	[Available subcommands](#available-subcommands)
		-	[Tips and Tricks](#tips-and-tricks)
	-	[Known Issues](#known-issues)
	-	[Issues](#issues)
	-	[Todo](#todo)
	-	[CHANGELOG](#changelog)
	-	[Contributing](#contributing)
	-	[License](#license)

### Dependencies

-	[blacktop/yara:3.4](https://hub.docker.com/r/blacktop/yara/)
-	[blacktop/volatility:2.5](https://hub.docker.com/r/blacktop/volatility/)

### Image Tags

```bash
REPOSITORY          TAG                 SIZE
blacktop/cuckoo     latest              309.7 MB
blacktop/cuckoo     2.0                 295.7 MB
blacktop/cuckoo     1.2                 238.7 MB
```

> NOTE: tags **latest** and **2.0** contain all of `cuckoosandbox/community`

### Installation

1.	Install [Docker](https://docs.docker.com).
2.	Install [docker-compose](https://docs.docker.com/compose/install/)
3.	Download [trusted build](https://hub.docker.com/r/blacktop/cuckoo/) from public [Docker Registry](https://hub.docker.com/): `docker pull blacktop/cuckoo`

### To Run on OSX

-	Install [Homebrew](http://brew.sh)

```bash
$ brew tap caskroom/cask
$ brew cask install virtualbox
$ brew install docker
$ brew install docker-machine
$ docker-machine create --driver virtualbox default
$ eval $(docker-machine env)
```

Or install [Docker for Mac](https://docs.docker.com/docker-for-mac/)

### Getting Started

```bash
$ curl -sL https://github.com/blacktop/docker-cuckoo/raw/master/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
# Cuckoo API is listening on port 8000 now.
$ curl $(docker-machine ip):8000/cuckoo/status
```

```json
{
  "cpuload": [
    0.01220703125,
    0.03515625,
    0.025390625
  ],
  "diskspace": {},
  "hostname": "195855fb100f",
  "machines": {
    "available": 0,
    "total": 0
  },
  "memory": 88.55692015425926,
  "tasks": {
    "completed": 0,
    "pending": 0,
    "reported": 0,
    "running": 0,
    "total": 0
  },
  "version": "2.0-dev"
}
```

Now navigate to `http://$(docker-machine ip)`

### Documentation

#### Usage

```bash
$ docker run -d --name mongo mongo
$ docker run -d --name postgres -e POSTGRES_PASSWORD=cuckoo postgres
$ docker run -d --name elasticsearch elasticsearch
$ docker run -d -v $(pwd)/conf:/cuckoo/conf:ro \
								--link postgres \
								-p 8000:1337 \
								blacktop/cuckoo api
$ docker run -d -v $(pwd)/conf:/cuckoo/conf:ro \
								--link mongo \
								--link elasticsearch \
								-p 80:31337 \
								blacktop/cuckoo web
```

> NOTE: If you want to customize the cuckoo configuration before launching you can link the **conf** folder into the container like is shown above.

Open a web browser and navigate to :

```bash
$ docker-machine ip
```

![cuckoo-submit](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/submit.png)
![cuckoo-dashboard](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/dashboard.png)

#### Available subcommands

```bash
docker run blacktop/cuckoo daemon       # start cuckoo.py
docker run blacktop/cuckoo submit       # run utils/submit.py
docker run blacktop/cuckoo process      # run utils/process.py
docker run blacktop/cuckoo api          # starts RESTFull API
docker run blacktop/cuckoo web          # starts web UI
docker run blacktop/cuckoo distributed  # runs distributed/app.py
docker run blacktop/cuckoo stats        # utils/stats.py
docker run blacktop/cuckoo help         # runs cuckoo.py --help
```

#### Tips and Tricks

As a convenience you can add the **docker-machine** IP to your **/etc/hosts** file:

```bash
$ echo $(docker-machine ip) dockerhost | sudo tee -a /etc/hosts
```

Now you can navigate to [http://dockerhost](http://dockerhost) from your host

### Known Issues

-	Currently won't work with VirtualBox, VMWare Workstation/Fusion or KVM/qemu, but I have an idea on how to do it. :wink:

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-cuckoo/issues/new) and I'll get right on it.

### Todo

-	[x] Install/Run Cuckoo Sandbox
-	[x] Break mongo out into a separate container using docker-compose
-	[x] Fix blacktop/yara and blacktop/volatility so I can use them as a base images for this image
-	[x] Create docker-entryporint.sh to use same container as daemon or web app or api or utility, etc
-	[ ] Figure out how to link to a analysis Windows VM (would be great if it was running in another container)
-	[ ] Correctly link mongo/elasticsearch in confs or document how to do it at runtime (or use docker-entryporint BEST OPTION)
- [x] add wait-for-it.sh to wait for postgres before API starts  
-	[ ] Web reverse proxy via Nginx with SSL
-	[ ] Add snort or suricata or both

### CHANGELOG

See [`CHANGELOG.md`](https://github.com/blacktop/docker-cuckoo/blob/master/CHANGELOG.md)

### Contributing

[See all contributors on GitHub](https://github.com/blacktop/docker-cuckoo/graphs/contributors).

Please update the [CHANGELOG.md](https://github.com/blacktop/docker-cuckoo/blob/master/CHANGELOG.md) and submit a [Pull Request on GitHub](https://help.github.com/articles/using-pull-requests/).

### License

MIT Copyright (c) 2015-2016 **blacktop**
