#!/bin/sh

# build/pull updated containers
docker pull alpine:latest
docker build -t alpinebase:latest dockerfiles/alpinebase
docker build -t sshbastion:latest dockerfiles/sshbastion
docker build -t moinmoin:latest dockerfiles/moinmoin
docker build -t reverseproxy:latest dockerfiles/reverseproxy
docker pull linuxserver/sabnzbd:latest
docker pull linuxserver/sonarr:latest
docker pull linuxserver/radarr:latest
docker pull linuxserver/couchpotato:latest
docker pull linuxserver/plexpy:latest

# restart all the things
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d
