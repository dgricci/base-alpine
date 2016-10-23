# Dockerfile for alpine based images
FROM alpine:3.4
MAINTAINER Didier Richard <didier.richard@ign.fr>

ARG GOSU_VERSION
ENV GOSU_VERSION ${GOSU_VERSION:-1.10}
ARG GOSU_DOWNLOAD_URL
ENV GOSU_DOWNLOAD_URL ${GOSU_DOWNLOAD_URL:-https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64}

RUN \
    apk update && \
    apk add --update \
        ca-certificates \
        curl \
        wget \
        git \
        openssh-client \
        gnupg \
    && \
    rm -rf /var/cache/apk/* && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -fsSL "$GOSU_DOWNLOAD_URL" -o /usr/bin/gosu && \
    curl -fsSL "${GOSU_DOWNLOAD_URL}.asc" -o /usr/bin/gosu.asc && \
    gpg --verify /usr/bin/gosu.asc && \
    rm -f /usr/bin/gosu.asc && \
    chmod +x /usr/bin/gosu

# Cf. https://github.com/docker-library/golang/blob/master/1.6/wheezy/Dockerfile
COPY adduserifneeded.sh /usr/local/bin/adduserifneeded.sh

# always launch this when starting a container (and then execute CMD ...)
ENTRYPOINT ["adduserifneeded.sh"]

#
CMD ["/bin/sh"]

