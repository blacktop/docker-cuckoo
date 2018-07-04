# Using VirtualBox

> **NOTE:** Requires VirtualBox 5+

## How does it work

The problem is in order to use `blacktop/cuckoo` on a host running both VirtualBox and docker would require either the ability to talk to a hypervisor from within the hypervisor *(VM breakout :scream:)* or have a way to mount the VirtualBox binary `vbox` inside the container.

However, that would require installing VirtualBox inside the container causing the docker image size to balloon and is also not a cross-platform solution (think Windows) because you also need to mount the vbox device `/dev/vboxdrv` into the running container.

We are instead communicating to the VirtualBox Web Service that VirtualBox can expose (via a SOAP API *yuck!* :confounded:) from the docker container running cuckoo.

However, the SOAP API changes a lot and I don't know when the last time you tried talking to a SOAP API was.  It is not fun...

That is where [@ilyaglow](https://github.com/ilyaglow) and [remotevbox](https://github.com/ilyaglow/remote-virtualbox) come into play.

**remotevbox** is a modern python wrapper around the SOAP API that makes it MUCH easier to use and @ilyaglow has a [pull request](https://github.com/cuckoosandbox/cuckoo/pull/1998) that adds it as an official cuckoo machinery waiting the be merged into the cuckoo repo now.

## How to set up VirtualBox Web Service

On the host you should create a user first that will run VirtualBox Web Service and will start/stop/import your VMs. If your user's uid is not *1000*, see Troubleshooting section below.

Here `vbox` indicates a user that manages vms, `sudouser` is your regular user that you use to manage docker and `root` is `root`.

Ensure that a file `/etc/default/virtualbox` has a following format:

```bash
VBOXWEB_HOST=your-external-ip # IP reachable from cuckoo docker
VBOXWEB_USER=your-vbox-user   # created user
```

As an alternative you can disable auth at all:
```bash
vbox@host:~$ vboxmanage setproperty websrvauthlibrary null
```

It is important to secure your VirtualBox Web Service with SSL using a reverse proxy or the built-in SSL option.

The latter will require generating a keyfile and appending:

- `VBOXWEB_SSL_KEYFILE=path-to-crt`
- `VBOXWEB_SSL_PASSWORDFILE=path-to-file-with-password`

as needed to `/etc/default/virtualbox`.

### Start VirtualBox Web Service:

```bash
root@host:# systemctl start vboxweb
```

or if a daemon doesn't available, run as a user that works with vms:
```bash
vbox@host:~$ vboxwebsrv --background --host ip-address
```

IP address should be reachable from docker container. Usually it is your external IP, or a subinterface. It is recommended to use iptables to harden this port access so `vboxwebservice` will be available only from a cuckoo docker.

Do not forget to import the certificate into the running cuckoo docker container when using a self-signed certificate.

## Configure the host

- Ensure that the VirtualBox `host-only` interface is created and set up properly (change 192.168.56.1 to the one you use for your vms):

```bash
vbox@host:~$ vboxmanage hostonlyif create
vbox@host:~$ vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1
```

*IMPORTANT*: Make a user that runs `vboxwebservice` an owner of these folders:

```bash
root@host:# chown -R vbox /mnt/cuckoo-storage
root@host:# chown -R vbox /path/to/docker-cuckoo/cuckoo-tmp
```

- Update `./conf/virtualbox_websrv.conf` file to reflect your current settings. If you decided to use no auth for your `vboxwebservice` leave `user` and `password` fields empty.

## Run using `docker-compose`

### Start the cuckoo services

```bash
sudouser@host:~$ git clone --depth 1 https://github.com/blacktop/docker-cuckoo.git
sudouser@host:~$ cd docker-cuckoo
sudouser@host:~/docker-cuckoo$ sudo docker-compose -f docker-compose.vbox.yml up -d
```

### Troubleshooting

- Check that `vboxwebservice` is actually running and can be talked to by `remotevbox` package (change <external ip> accordingly:

```bash
sudouser@host:~$ pip install remotevbox --user
sudouser@host:~$ python -c 'import remotevbox; vbox = remotevbox.connect("http://<external-ip>:18083", "VBOXWEB-USER", "VBOXWEB-USER-PASSWORD"); print(vbox.get_version()); print(vbox.list_machines()); vbox.disconnect()'
```

The last command should return something like the following:
```
5.2.12
['cuckoo-win81x64']
```

- UID of cuckoo user inside docker and the user that runs `vboxwebservice` should match:

```bash
sudouser@host:~/docker-cuckoo$ id -u vbox
1000
sudouser@host:~/docker-cuckoo$ sudo docker-compose exec cuckoo ash -c 'id -u cuckoo'
1000
```

> You can rebuild cuckoo, api and web docker images with a different uid by changing `docker-compose.vbox.yml` build argument `DEFAULT_CUCKOO_UID` or just uncomment and set `CUCKOO_UID` environment variable accordingly in `vbox/config-file.env`. What's the difference? The latter allows you to not spend time rebuilding image, but will add overhead to containers restart time.
