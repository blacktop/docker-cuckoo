Usage
=====

```bash
$ docker run -d --name mongo mongo
$ docker run -d --name postgres -e POSTGRES_PASSWORD=cuckoo postgres
$ docker run -d --name elasticsearch elasticsearch
$ docker run -d -v $(pwd)/conf:/cuckoo/conf:ro \
								--name cuckoo-api \
								--link postgres \
								-p 8000:1337 \
								blacktop/cuckoo api
$ docker run -d -v $(pwd)/conf:/cuckoo/conf:ro \
								--name cuckoo-web \
								--link mongo \
								--link elasticsearch \
								-p 80:31337 \
								blacktop/cuckoo web
```

> **NOTE:** If you want to customize the cuckoo configuration before launching you can link the **conf** folder into the container like is shown above.

##### Now Navigate To

-	With [Docker for Mac](https://docs.docker.com/engine/installation/mac/) : `http://localhost`
-	With [docker-machine](https://docs.docker.com/machine/) : `http://$(docker-machine ip)`
-	With [docker-engine](https://docker.github.io/engine/installation/) : `$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' cuckoo-web)`

![cuckoo-submit](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/submit.png)  
![cuckoo-dashboard](https://github.com/blacktop/docker-cuckoo/raw/master/docs/img/dashboard.png)  
