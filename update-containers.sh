#!/bin/sh

COMPOSE_HTTP_TIMEOUT=120

# build/pull updated containers
docker pull alpine:latest
docker build -t alpinebase:latest dockerfiles/alpinebase
docker build -t moinmoin:latest dockerfiles/moinmoin
docker build -t reverseproxy:latest dockerfiles/reverseproxy
docker pull linuxserver/sabnzbd:latest
docker pull linuxserver/sonarr:latest
docker pull linuxserver/radarr:latest
docker pull linuxserver/tautulli:latest
docker pull grafana/grafana:latest
docker pull prom/prometheus:latest
docker pull prom/alertmanager:latest
docker pull prom/node-exporter:latest

# restart all the things
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d
