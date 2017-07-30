#!/bin/sh

# build/pull updated containers
docker build -t reverseproxy:latest dockerfiles/reverseproxy
docker build -t moinmoin:latest dockerfiles/moinmoin
docker pull linuxserver/sabnzbd:latest
docker pull linuxserver/sonarr:latest
docker pull linuxserver/couchpotato:latest

# restart all the things
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml -d up