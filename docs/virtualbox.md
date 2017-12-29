# Using VirtualBox

> **NOTE:** Requires VirtualBox 5+

## How to set up VirtualBox Web Service

On the host you should create a user first that will run VirtualBox Web Service and will start/stop/import your VMs.

Ensure that a file `/etc/default/virtualbox` has a following format:

```bash
VBOXWEB_HOST=your-external-ip # IP reachable from cuckoo docker
VBOXWEB_USER=your-vbox-user   # created user
```

It is important to secure you VirtualBox Web Service with SSL using reverse proxy or built-in SSL option. The latter will require generating keyfile and appending `VBOXWEB_SSL_KEYFILE=path-to-crt` and `VBOXWEB_SSL_PASSWORDFILE=path-to-file-with-password` if needed to `/etc/default/virtualbox`.

Start VirtualBox Web Service:

```bash
$ systemctl start vboxweb
```

Do not forget to import certificate into Cuckoo docker container if you use self-signed certificate.

## Run using `docker-compose`

Ensure that VirtualBox Host-only interface is created and your `vboxnet0` IP address is `192.168.56.1`.

If it differs, change a Cuckoo container `ports:` section accordingly.

Make a folder `/mnt/cuckoo-storage` (or any other one but change it in the `docker-compose.vbox.yml` then) on the host that will be used to store all cuckoo analysis data.

Change `./conf/virtualbox_websrv.conf` appropriately.

```bash
$ docker-compose -f docker-compose.vbox.yml up -d
```
