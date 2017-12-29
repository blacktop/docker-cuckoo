# Using VirtualBox

> **NOTE:** Requires VirtualBox 5+

## How does it work

The problem is in order to use `blacktop/cuckoo` on a host running both VirtualBox and docker would require either the ability to talk to a hypervisor from within the hypervisor *(VM breakout :scream:)* or have a way to mount the VirtualBox binary `vbox` inside the container.

However, that would require installing VirtualBox inside the container making the docker image size to balloon and is also not a cross-platform solution (think Windows) because you also need to mount the vbox device `/dev/vboxdrv` into the running container.

We are instead communicating to the VirtualBox Web Service that VirtualBox can expose (via a SOAP API *yuck!* :confounded:) from the docker container running cuckoo.

However, the SOAP API changes a lot and I don't know when the last time you tried talking to a SOAP API was.  It is not fun...

That is where [@ilyaglow](https://github.com/ilyaglow) and [remotevbox](https://github.com/ilyaglow/remote-virtualbox) come into play.

**remotevbox** is a modern python wrapper around the SOAP API that makes it MUCH easier to use and he has a [pull request](https://github.com/cuckoosandbox/cuckoo/pull/1998) that adds it as an official cuckoo machinery waiting the be merged into the cuckoo repo now.

## How to set up VirtualBox Web Service

On the host you should create a user first that will run VirtualBox Web Service and will start/stop/import your VMs.

Ensure that a file `/etc/default/virtualbox` has a following format:

```bash
VBOXWEB_HOST=your-external-ip # IP reachable from cuckoo docker
VBOXWEB_USER=your-vbox-user   # created user
```

It is important to secure your VirtualBox Web Service with SSL using a reverse proxy or the built-in SSL option.

The latter will require generating a keyfile and appending:

- `VBOXWEB_SSL_KEYFILE=path-to-crt`
- `VBOXWEB_SSL_PASSWORDFILE=path-to-file-with-password`

as needed to `/etc/default/virtualbox`.

### Start VirtualBox Web Service:

```bash
$ systemctl start vboxweb
```

Do not forget to import the certificate into the running cuckoo docker container when using a self-signed certificate.

## Run using `docker-compose`

### Start the cuckoo services

```bash
$ git clone --depth 1 https://github.com/blacktop/docker-cuckoo.git
$ cd docker-cuckoo
$ docker-compose -f docker-compose.vbox.yml up -d
```

### Troubleshooting

- Ensure that the VirtualBox `host-only` interface is created and your `vboxnet0` IP address is `192.168.56.1`

> If it differs, change the cuckoo service `ports:` section accordingly in the `docker-compose.vbox.yml` file.

- Create a folder `/mnt/cuckoo-storage` on the host that will be used to store all cuckoo analysis data
- Update `./conf/virtualbox_websrv.conf` file to reflect your current settings
