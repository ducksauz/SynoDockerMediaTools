FROM alpine
MAINTAINER John Duksta <john@duksta.org>

# MoinMoin source install lovingly borrowed from 
# https://github.com/dperson/moinmoin/blob/master/Dockerfile
 
# Install python and moin install dependencies
RUN apk --no-cache add --update python \
    py-markdown \
    curl \
    patch

# Install MoinMoin 1.9.9 and required patch
RUN export version='1.9.9' && \
    export patch='561b7a9c2bd91b61d26cd8a5f39aa36bf5c6159e' && \
    export url='https://bitbucket.org/thomaswaldmann/moin-1.9/commits' && \
    export sha256sum='4397d7760b7ae324d7914ffeb1a9eeb15e09933b61468072acd3' && \
    file="moin-${version}.tar.gz" && \
    echo "downloading $file ..." && \
    curl -LOSs http://static.moinmo.in/files/$file && \
    echo "downloading patch ${url}/${patch}/raw ..." && \
    curl -LOSs "${url}/${patch}/raw" && \
    echo "verifying checksum ..." && \
    sha256sum $file | grep -q "$sha256sum" || \
    { echo "expected $sha256sum, got $(sha256sum $file)"; exit 13; } && \
    echo "untarring ..." && \
    mkdir moinmoin && \
    tar -xf $file -C moinmoin --strip-components=1 && \
    (cd moinmoin && \
    echo "applying patch ..." && \
    patch -p1 < ../raw && \
    echo "installing moinmoin ${version} ..." && \
    python setup.py install --force --prefix=/usr >/dev/null) && \
    mkdir /moin && \
    chown -Rh nobody /moin

# Post install cleanup    
RUN apk --no-cache del curl patch \
    && rm -rf /var/cache/apk/*

# add in my startup script
COPY moin.sh /usr/bin

VOLUME ["/moin"]

EXPOSE 9100

ENTRYPOINT ["moin.sh"]
