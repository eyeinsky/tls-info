#!/usr/bin/env bash

cert_client() {
    COMMON_NAME="$1"
    mkdir -p client_cert
    NAME="cert_client_$COMMON_NAME"
    openssl req -new -x509 -nodes -text \
	    -newkey 2048 -keyout "${NAME}.key" \
	    -out "${NAME}.crt" \
	    -subj "/CN=${COMMON_NAME}"
    openssl pkcs12 -aes256 -password 'pass:password123' -export \
	    -inkey "${NAME}.key" -in "${NAME}.crt" \
	    -out "${NAME}.pfx"
    openssl x509 -in "${NAME}.crt" \
	    -outform der -out "${NAME}.der"
}

cert_server() {
    openssl \
        req -x509 -newkey rsa:4096 \
        -days 365 -nodes \
        -keyout cert_server_key.pem \
	-subj "/CN=localhost" \
        -out cert_server_cert.pem
}

$@
