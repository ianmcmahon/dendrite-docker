FROM golang:1.14-alpine
MAINTAINER Ian McMahon <facetious.ian@gmail.com>

ENV DOMAIN "localhost"
ENV CLIENT_URL "http://localhost:7771"
ENV SYNC_URL "http://localhost:7773"
ENV MEDIA_URL "http://localhost:7774"
ENV ROOM_URL "http://localhost:7775"
ENV FUNCTION "CLIENT_PROXY"

VOLUME /config
VOLUME /var/dendrite/media

RUN apk add --update git openssl bash gcc libc-dev
RUN mkdir /dendrite && \
    git clone https://github.com/matrix-org/dendrite /dendrite
WORKDIR /dendrite
RUN ./build.sh
RUN test -f server.key || openssl req -x509 -newkey rsa:4096 -keyout server.key -out server.crt -days 3650 -nodes -subj /CN=localhost
RUN test -f matrix_key.pem || ./bin/generate-keys -private-key matrix_key.pem
ADD dendrite.yaml .

EXPOSE 8008

VOLUME /var/dendrite/media

ENTRYPOINT ["/bin/bash"]
