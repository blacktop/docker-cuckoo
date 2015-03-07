# ![cuckoo-logo](https://raw.githubusercontent.com/blacktop/docker-cuckoo/master/logo.png) Dockerfile

This repository contains a **Dockerfile** of [Cuckoo Sandbox](http://www.cuckoosandbox.org/) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/blacktop/cuckoo/) published to the public [Docker Registry](https://index.docker.io/).

### Dependencies

* [debian:wheezy](https://index.docker.io/_/debian/)

### Image Sizes
| Image | Virtual Size | cuckoo v1.2.0 | TOTAL     |
|:------:|:-----------:|:-------------:|:---------:|
| debian | 85.1  MB    | 508.9 MB      | 594 MB    |

### Image Tags
```bash
$ docker images

REPOSITORY          TAG                 VIRTUAL SIZE
blacktop/cuckoo        latest              594   MB
blacktop/cuckoo        1.2.0               594   MB
```

### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://index.docker.io/u/blacktop/cuckoo/) from public [Docker Registry](https://index.docker.io/): `docker pull blacktop/cuckoo`

#### Alternatively, build an image from Dockerfile
```bash
$ docker build -t blacktop/cuckoo github.com/blacktop/docker-cuckoo
```
### Usage
```bash
$ docker run -d --name cuckoo -p 80:80 blacktop/cuckoo
```
Now navigate to `$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' cuckoo):80`

![cuckoo-dashboard](https://raw.githubusercontent.com/blacktop/docker-cuckoo/master/dashboard.png)

### To Run on OSX
 - Install [Homebrew](http://brew.sh)

```bash
$ brew install cask
$ brew cask install virtualbox
$ brew install docker
$ brew install boot2docker
$ boot2docker init
$ boot2docker up
$ $(boot2docker shellinit)
```
> If you want to cusomize the cuckoo configuration before launching you can link the conf folder into the container like so:

```bash
$ docker run -d -v $(pwd)/conf:/cuckoo/conf:ro -p 80:80 blacktop/cuckoo
```

Open a web browser and navigate to :
```bash
$(boot2docker ip):8080
```

As a convience you can add the **boot2docker** IP to your **/etc/hosts** file:
```bash
$ echo $(boot2docker ip) dockerhost | sudo tee -a /etc/hosts
```
Now you can navigate to http://dockerhost from your host

### Todo
- [x] Install/Run Cuckoo Sandbox
- [ ] Break mongo out into a separate container using docker-compose
- [ ] Figure out how to link to a analysis Windows VM (would be great if it was running in another container)
