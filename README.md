![cuckoo-logo](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/logo.png) Dockerfile-beta
======================================================================================================

[![CircleCI](https://circleci.com/gh/blacktop/docker-cuckoo.png?style=shield)](https://circleci.com/gh/blacktop/docker-cuckoo) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/cuckoo.svg)](https://hub.docker.com/r/blacktop/cuckoo/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/cuckoo.svg)](https://hub.docker.com/r/blacktop/cuckoo/) [![Docker Image](https://img.shields.io/badge/docker%20image-367MB%20MB-blue.svg)](https://hub.docker.com/r/blacktop/cuckoo/)

This repository contains a **Dockerfile** of [Cuckoo Sandbox](https://github.com/cuckoosandbox/cuckoo).

> :construction: WARNING: Currently only works with remote machinery: **esx, vsphere and xenserver**.

**Table of Contents**

-	[Dependencies](#dependencies)
-	[Image Tags](#image-tags)
-	[Installation](#installation)
-	[To Run on OSX](#to-run-on-osx)
-	[Getting Started](#getting-started)
-	[Documentation](#documentation)
-	[Known Issues](#known-issues)
-	[Issues](#issues)
-	[Todo](#todo)
-	[CHANGELOG](#changelog)
-	[Contributing](#contributing)
-	[License](#license)

### Dependencies

-	[blacktop/yara:3.5](https://hub.docker.com/r/blacktop/yara/)
-	[blacktop/volatility:2.6](https://hub.docker.com/r/blacktop/volatility/)

### Image Tags

```bash
REPOSITORY          TAG                 SIZE
blacktop/cuckoo     latest              367MB
blacktop/cuckoo     2.0                 367MB
blacktop/cuckoo     modified (WIP)      317.1 MB
blacktop/cuckoo     1.2                 258.6 MB
```

> **NOTE:** * tags **latest** and **2.0** contain all of `cuckoosandbox/community`  
>  * tag **modified** is the *awesome* **spender-sandbox** version of cuckoo and contains all of `spender-sandbox/community-modified`

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
# For docker-machine
$ curl $(docker-machine ip):8000/cuckoo/status
# For Docker for Mac
$ curl localhost:8000/cuckoo/status
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

##### Now Navigate To

-	With [docker-machine](https://docs.docker.com/machine/) : `http://$(docker-machine ip)`
-	With [Docker for Mac](https://docs.docker.com/engine/installation/mac/) : `http://localhost`

![cuckoo-dashboard](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/2.0/dashboard.png)

### Documentation

-	[Usage](https://github.com/blacktop/docker-cuckoo/blob/master/docs/usage.md)
-	[Available Subcommands](https://github.com/blacktop/docker-cuckoo/blob/master/docs/subcmd.md)
-	[Running Modified Version](https://github.com/blacktop/docker-cuckoo/blob/master/docs/modified.md)
-	[Tips and Tricks](https://github.com/blacktop/docker-cuckoo/blob/master/docs/tips-tricks.md)

### Known Issues

Currently won't work with VirtualBox, VMWare Workstation/Fusion or KVM/qemu, but I have an idea on how to do it. [:wink:](https://github.com/blacktop/vm-proxy)

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-cuckoo/issues/new) and I'll get right on it.

### Todo

-	[x] Install/Run Cuckoo Sandbox
-	[x] Break mongo out into a separate container using docker-compose
-	[x] Fix blacktop/yara and blacktop/volatility so I can use them as a base images for this image
-	[x] Create docker-entryporint.sh to use same container as daemon or web app or api or utility, etc
-	[ ] Figure out how to link to a analysis Windows VM (would be great if it was running in another container)
-	[x] Correctly link mongo/elasticsearch in confs or document how to do it at runtime (or use docker-entryporint BEST OPTION)
-	[x] add wait-for-it.sh to wait for postgres before API starts  
-	[ ] Web reverse proxy via Nginx with SSL
-	[ ] Add snort or suricata or both
-	[x] Get `modified` version of cuckoo to install/run in docker

### CHANGELOG

See [`CHANGELOG.md`](https://github.com/blacktop/docker-cuckoo/blob/master/CHANGELOG.md)

### Contributing

[See all contributors on GitHub](https://github.com/blacktop/docker-cuckoo/graphs/contributors).

Please update the [CHANGELOG.md](https://github.com/blacktop/docker-cuckoo/blob/master/CHANGELOG.md) and submit a [Pull Request on GitHub](https://help.github.com/articles/using-pull-requests/).

### License

MIT Copyright (c) 2015-2017 **blacktop**
