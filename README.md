![cuckoo-logo](https://raw.githubusercontent.com/blacktop/docker-cuckoo/master/logo.png)
Cuckoo Sandbox Dockerfile
=========================

This repository contains a **Dockerfile** of [Cuckoo Sandbox](http://www.cuckoosandbox.org/) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/blacktop/cuckoo/) published to the public [Docker Registry](https://index.docker.io/).

### Dependencies

* [debian:wheezy](https://index.docker.io/_/debian/)

### Image Sizes
| Image | Virtual Size | cuckoo v1.2.0 | TOTAL     |
|:------:|:-----------:|:-------------:|:---------:|
| debian | 85.1  MB    | 446.1 MB      | 517.8 MB  |

### Image Tags
```bash
$ docker images

REPOSITORY          TAG                 VIRTUAL SIZE
blacktop/cuckoo        latest              542   MB
blacktop/cuckoo        1.2.0               531.2 MB
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
$ docker run -i -t -v /path/to/folder/pcap:/pcap:rw blacktop/cuckoo -r heartbleed.pcap local
```
#### Output:
```bash

```
```bash

```
#### Or use your own
```bash
$ docker run -it -v /path/to/pcap:/pcap:rw blacktop/cuckoo
```

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
Add the following to your bash or zsh profile

```bash
alias cuckoo='docker run -it --rm -v `pwd`:/pcap:rw blacktop/cuckoo $@'
```
#### Usage


### Todo
- [x] Install/Run Cuckoo Sandbox
- [ ] ...
