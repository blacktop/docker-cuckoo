Running Modified Version
========================

```bash
$ docker run -d --name elasticsearch blacktop/elasticsearch:5.6
$ docker run -d --name postgres -e POSTGRES_PASSWORD=cuckoo postgres
# Start cuckoo API
$ docker run -d --name cuckoo-api \
				--link postgres \
				-p 8000:1337 \
				blacktop/cuckoo:modified api
# Start cuckoo web UI				
$ docker run -d --name cuckoo-web \
				--link elasticsearch \
				-p 80:31337 \
				blacktop/cuckoo:modified web
```

> **NOTE:** If you want to customize the cuckoo configuration before launching you can link the **conf** folder into the container like so: `docker run -d -v $(pwd)/conf:/cuckoo/conf blacktop/cuckoo web`

##### Now Navigate To

-	With [Docker for Mac](https://docs.docker.com/engine/installation/mac/) : `http://localhost`
-	With [docker-machine](https://docs.docker.com/machine/) : `http://$(docker-machine ip)`
-	With [docker-engine](https://docker.github.io/engine/installation/) : `$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' cuckoo-web)`

![cuckoo-submit](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/modified.png)  
![cuckoo-dashboard](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/modified-api.png)  
