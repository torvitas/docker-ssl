#!/bin/bash

# prepare environment
. /usr/local/lib/ssl/entrypoint.environment.sh
. /usr/local/lib/ssl/entrypoint.functions.sh
. /usr/local/lib/ssl/template.renderer.sh

# make sure there the specified ca exists
if [ ! -f ${CA_KEY} ]; then
    cd ${CA_FOLDER}
    echo '>> Rendering ca config template.'
    render /usr/local/etc/ssl/template/ca.cnf.template -- > /usr/local/etc/ssl/ca.cnf
    touch ${CA_FOLDER}'/index.txt'
    echo '01' > ${CA_FOLDER}'/serial.txt'
    echo '>> Creating ca certificate and key.'
    openssl req -x509 -config /usr/local/etc/ssl/ca.cnf -newkey rsa:4096 -sha256 -nodes -out ${CA_CRT_FILE} -outform PEM
    openssl x509 -in ${CA_CRT_FILE} -text -noout
    ls -lah ${CA_FOLDER}
else
    echo '>> Using existing CA.'
fi

# create cert if necessary
if [ ! -f ${KEY} ]; then
    cd ${CERTS_FOLDER}
    host_setup=1
    echo '>> Rendering host config template.'
    render /usr/local/etc/ssl/template/host.cnf.template -- > /usr/local/etc/ssl/host.cnf
    cat /usr/local/etc/ssl/host.cnf
    echo '>> Creating certificate signing request.'
    openssl req -config /usr/local/etc/ssl/host.cnf -newkey rsa:2048 -sha256 -nodes -out ${CSR_FILE} -outform PEM
    openssl req -text -noout -verify -in ${CSR_FILE}
    echo '>> Signing certificate using ca in '${CA_FOLDER}
    openssl ca -batch -config /usr/local/etc/ssl/ca.cnf -policy signing_policy -extensions signing_req -out ${CRT_FILE} -infiles ${CSR_FILE}
else
    echo '>> Using existing certificate, doing nothing.'
fi

# publish cert to nginx proxy if necessary
if [ ! -f ${PROXY_CERTS}${KEY_FILE} ]; then
    mkdir -p ${PROXY_CERTS}
    cp -v ${KEY} ${PROXY_CERTS}
    cp -v ${CRT} ${PROXY_CERTS}
else
    echo '>> Using existing proxy certificate, doing nothing.'
fi

if [ ! host_setup ]; then
    echo ">> CSR:"
    openssl req -in ${CSR} -noout -text
    echo ">> CRT:"
    cat ${CRT}
fi

exec "$@"
