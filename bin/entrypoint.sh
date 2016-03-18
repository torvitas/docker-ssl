#!/bin/bash

# prepare environment
. /usr/local/lib/ssl/entrypoint.environment.sh
. /usr/local/lib/ssl/entrypoint.functions.sh
. /usr/local/lib/ssl/template.renderer.sh

# make sure there the specified ca exists
if [ ! -f 'local/ca/'${CA_CRT_FILE} ]; then
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
    cp -v '/local/ca/'${CA_CRT_FILE} ${CA_CRT}
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
    openssl req -config /usr/local/etc/ssl/host.cnf -newkey rsa:2048 -sha256 -nodes -out ${CSR_FILE}
    openssl req -text -noout -verify -in ${CSR_FILE}
    echo '>> Signing certificate using ca in '${CA_FOLDER}
    openssl ca -batch -config /usr/local/etc/ssl/ca.cnf -policy signing_policy -extensions signing_req -out ${CRT_FILE} -infiles ${CSR_FILE}
    openssl x509 -in ${CRT_FILE} -text -noout
else
    echo '>> Using existing certificate, doing nothing.'
fi

# publish cert to nginx proxy if necessary
if [ ! -f ${PROXY_CERTS}${KEY_FILE} ]; then
    mkdir -p ${PROXY_CERTS}
    cp -v ${CRT} ${PROXY_CERTS}'/'
    cp -v ${KEY} ${PROXY_CERTS}'/'
else
    echo '>> Using existing proxy certificate, doing nothing.'
fi

# publish ca to local machine if necessary
if [ ! -f 'local/ca/'${CA_CRT_FILE} ]; then
    mkdir -p '/local/ca/'
    cp -v ${CA_CRT} '/local/ca/'
fi

if [ ! host_setup ]; then
    echo ">> CSR:"
    openssl req -in ${CSR} -noout -text
    echo ">> CRT:"
    openssl x509 -in ${CRT} -text -noout
fi

chown 1000.1000 -R ${CERTS_FOLDER}
chown 1000.1000 -R ${CA_FOLDER}

exec "$@"
