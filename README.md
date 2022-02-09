# DynDNS update script for OVH domains

![Build image](https://github.com/webhainaut/ovh-dyndns-docker/workflows/Build%20ovh-dyndns%20image/badge.svg)
[![Build Status](https://travis-ci.com/webhainaut/ovh-dyndns-docker.svg?branch=master)](https://travis-ci.com/webhainaut/ovh-dyndns-docker)

this is based on *ovh-dyndns* from [Ambroisemaupate work](https://github.com/ambroisemaupate/Docker).

https://docs.ovh.com/fr/domains/utilisation-dynhost/

Check every 5 minutes you WAN IP and if changed call OVH entry-point to update
your DynDNS domain.

```
docker run -d --name="ovh-dyndns" \
    -e "TZ=Europe/Rome" \
    -e "HOST=mydynamicdomain.domain.com" \
    -e "LOGIN=mylogin" \
    -e "PASSWORD=mypassword" \
    napalmzrpi/ovh-dyndns-docker
```

## Docker-compose

```
version: "3"
services:
  crond:
    image: napalmzrpi/ovh-dyndns-docker
    environment:
      TZ: Europe/Rome
      HOST: mydynamicdomain.domain.com
      LOGIN: mylogin
      PASSWORD: mypassword
    restart: always
```

## Customize external NS server

By default, we use Google DNS to check your current DynDNS IP, but you can choose an
other DNS overriding `NSSERVER` env var:

```
version: "3"
services:
  crond:
    image: napalmzrpi/ovh-dyndns-docker
    environment:
      TZ: Europe/Rome
      HOST: mydynamicdomain.domain.com
      LOGIN: mylogin
      PASSWORD: mypassword
      NSSERVER: 192.168.1.1
    restart: always
```

## Customize crond interval

By default, provided crontab file is set to check your current IP every 5 minutes.
You can provide a modified one with different interval and map it to the correct volume.
(Start from the one you can find in github page.)

```
version: "3"
services:
  crond:
    image: napalmzrpi/ovh-dyndns-docker
    environment:
      TZ: Europe/Rome
      HOST: mydynamicdomain.domain.com
      LOGIN: mylogin
      PASSWORD: mypassword
      NSSERVER: 192.168.1.1
    volumes:
      - /path/to/file/cronjob.txt:/etc/cron.d/dynhost
    restart: always
```
