# dockerized dionaea


[dionaea](http://dionaea.carnivore.it/) is low interaction honeypot with focus on capturing malware.

This repository contains the necessary files to create a *dockerized* version of dionaea.

This dockerized version is part of the **[T-Pot community honeypot](http://dtag-dev-sec.github.io/)** of Deutsche Telekom AG.

The `Dockerfile` contains the blueprint for the dockerized dionaea and will be used to setup the docker image.  

The `dionaea.conf` is tailored to fit the T-Pot environment.

The `supervisord.conf` is used to start dionaea under supervision of supervisord.

Using upstart, copy the `upstart/dionaea.conf` to `/etc/init/dionaea.conf` and start using

    service dionaea start

This will make sure that the docker container is started with the appropriate rights and port mappings. Further, it autostarts during boot.

By default all data will be stored in `/data/dionaea/` until the honeypot service will be restarted which is by default every 24 hours. If you want to keep data persistently simply rename `/data/persistence.off` to `/data/persistence.on`. Be advised to establish some sort of log management if you wish to do so.

# Dionaea Dashboard

![Dionaea Dashboard](https://raw.githubusercontent.com/dtag-dev-sec/dionaea/master/doc/dashboard.png)
