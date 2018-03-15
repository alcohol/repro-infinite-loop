## Repro case for infite-loop in exception_handlers

This repository aims to reproduce the following issue:

![stacktrace-timeline.png](stacktrace-timeline.png)

Required:

 - Docker Compose 1.14 or newer
 - Docker 17.06 or newer
 - a valid new relic license for the PHP extension
 - a Sentry account

Create a file named `docker-compose.override.yml` with the following contents:

``` yaml
version: '3.3'
services:
  php:
    build:
      args:
        - nr_license_key=YOUR-LICENSE-KEY
    environment:
      - SENTRY_DSN=YOUR-SENTRY-DSN
```

Reproduction steps:

``` bash
HOST_UID=$(id -u) HOST_GID=$(id -g) docker-compose up --build -d

# install deps
HOST_UID=$(id -u) HOST_GID=$(id -g) docker-compose exec php composer install

# first request will succeed
curl localhost:8000

# subsequent requests will get stuck in an infinite loop
curl localhost:8000
```
