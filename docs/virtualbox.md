# Using VirtualBox

> **NOTE:** Requires VirtualBox 5+

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

- Ensure that the VirtualBox `host-only` interface is created and your `vboxnet0` IP address is `192.168.56.1`

> If it differs, change the cuckoo service `ports:` section accordingly in the `docker-compose.vbox.yml` file.

- Create a folder `/mnt/cuckoo-storage` on the host that will be used to store all cuckoo analysis data
- Update `./conf/virtualbox_websrv.conf` file to reflect your current settings

### Start the cuckoo services

```bash
$ docker-compose -f docker-compose.vbox.yml up -d
```
