FROM golang:1.14-alpine
MAINTAINER Ian McMahon <facetious.ian@gmail.com>

VOLUME /var/dendrite/media

RUN apk add --update git openssl bash gcc libc-dev
RUN mkdir /dendrite && \
    git clone https://github.com/matrix-org/dendrite /dendrite
WORKDIR /dendrite
RUN ./build.sh
RUN test -f server.key || openssl req -x509 -newkey rsa:4096 -keyout server.key -out server.crt -days 3650 -nodes -subj /CN=localhost
RUN test -f matrix_key.pem || ./bin/generate-keys -private-key matrix_key.pem
ADD dendrite.yaml .
ADD proxy.sh .
RUN chmod a+x proxy.sh

ENTRYPOINT ["/bin/bash"]
