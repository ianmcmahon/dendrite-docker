#!/bin/sh

/dendrite/bin/federation-api-proxy -bind-address ":8448" \
	-federation-api-url http://federation-api:7772 \
	-media-api-server-url http://media-api:7774 > /var/log/federation-proxy.log &

/dendrite/bin/client-api-proxy -bind-address ":8008" \
	-client-api-server-url http://client-api:7771 \
	-media-api-server-url http://media-api:7774 \
	-public-rooms-api-server-url http://public-rooms-api:7775 \
	-sync-api-server-url http://sync-api:7773 > /var/log/client-proxy.log &

tail -f /var/log/*proxy.log
