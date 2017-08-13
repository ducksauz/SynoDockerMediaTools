FROM alpine:latest
MAINTAINER John Duksta <john@duksta.org>
# My alpine base image that is patched to current with every build

# Patch Alpine to current
RUN apk --no-cache upgrade \
    && rm -rf /var/cache/apk/*

