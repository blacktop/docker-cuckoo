Tips and Tricks
===============

As a convenience you can add the **docker-machine** IP to your **/etc/hosts** file:

```bash
$ echo $(docker-machine ip) dockerhost | sudo tee -a /etc/hosts
```

Now you can navigate to [http://dockerhost](http://dockerhost) from your host
