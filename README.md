# ![cuckoo-logo](https://raw.githubusercontent.com/blacktop/docker-cuckoo/master/files/logo.png) Dockerfile

[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
[![Docker Stars](https://img.shields.io/docker/stars/blacktop/cuckoo.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/cuckoo.svg)][hub]
[![Image Size](https://img.shields.io/imagelayers/image-size/blacktop/cuckoo/latest.svg)](https://imagelayers.io/?images=blacktop/cuckoo:latest)
[![Image Layers](https://img.shields.io/imagelayers/layers/blacktop/cuckoo/latest.svg)](https://imagelayers.io/?images=blacktop/cuckoo:latest)

This repository contains a **Dockerfile** of [Cuckoo Sandbox](http://www.cuckoosandbox.org/) for [Docker](https://www.docker.io/)'s [trusted build](https://registry.hub.docker.com/u/blacktop/cuckoo/) published to the public [Docker Registry](https://index.docker.io/).

### Dependencies

* [debian:wheezy](https://index.docker.io/_/debian/)

### Image Size
[![](https://badge.imagelayers.io/blacktop/cuckoo:latest.svg)](https://imagelayers.io/?images=blacktop/cuckoo:latest 'Get your own badge on imagelayers.io')

### Image Tags
```bash
$ docker images

REPOSITORY          TAG                 VIRTUAL SIZE
blacktop/cuckoo        latest              448.5 MB
blacktop/cuckoo        1.2.0               444.8 MB
```

### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://registry.hub.docker.com/u/blacktop/cuckoo/) from public [Docker Registry](https://index.docker.io/): `docker pull blacktop/cuckoo`

#### Alternatively, build an image from Dockerfile
```bash
$ docker build -t blacktop/cuckoo github.com/blacktop/docker-cuckoo
```
### Usage
```bash
$ docker run -d --name cuckoo -p 80:80 blacktop/cuckoo
```
Now navigate to `$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' cuckoo)`

### To Run on OSX
 - Install [Homebrew](http://brew.sh)

```bash
$ brew install caskroom/cask/brew-cask
$ brew cask install virtualbox
$ brew install docker
$ brew install docker-machine
$ docker-machine create --driver virtualbox dev
$ eval $(docker-machine env dev)
```
> If you want to customize the cuckoo configuration before launching you can link the **conf** folder into the container like so:

```bash
$ docker run -d -v $(pwd)/conf:/cuckoo/conf:ro -p 80:80 blacktop/cuckoo
```

Open a web browser and navigate to :

```bash
$(docker-machine ip dev)
```

As a convenience you can add the **docker-machine** IP to your **/etc/hosts** file:

```bash
$ echo $(docker-machine ip dev) dockerhost | sudo tee -a /etc/hosts
```
Now you can navigate to [http://dockerhost](http://dockerhost) from your host

![cuckoo-dashboard](https://raw.githubusercontent.com/blacktop/docker-cuckoo/master/files/dashboard.png)

### Todo
- [x] Install/Run Cuckoo Sandbox
- [x] Break mongo out into a separate container using docker-compose
- [ ] Create docker-entryporint.sh to use same container as daemon or web app or api or utility, etc
- [ ] Figure out how to link to a analysis Windows VM (would be great if it was running in another container)

[hub]: https://hub.docker.com/r/blacktop/cuckoo/
