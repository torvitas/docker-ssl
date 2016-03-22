#!/bin/bash

# prepare environment
. /usr/local/lib/ssl/entrypoint.environment.sh
. /usr/local/lib/ssl/entrypoint.functions.sh
. /usr/local/lib/ssl/template.renderer.sh

echo $(date +%s) > ${CA_FOLDER}'/'serial.txt

# make sure there the specified ca exists
if [ ! -f ${CA_CRT} ]; then
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
    echo '>> Found existing CA '${CA_CRT}
fi

# create cert if necessary
if [ ! -f ${CRT} ]; then
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
    echo '>> Found existing certificate '${CRT}''
fi

# publish cert to local folder if necessary
if [ ! -f ${LOCAL_CERTS}'/'${CRT_FILE} ]; then
    mkdir -p ${LOCAL_CERTS}
    cp -v ${CRT} ${LOCAL_CERTS}'/'
else
    echo '>> Certificate '${CRT_FILE}' already published to local.'
fi

# publish key to local folder if necessary
if [ ! -f ${LOCAL_CERTS}'/'${KEY_FILE} ]; then
    mkdir -p ${LOCAL_CERTS}
    cp -v ${KEY} ${LOCAL_CERTS}'/'
else
    echo '>> Key '${KEY_FILE}' already published to local.'
fi

# publish ca to local machine if necessary
if [ ! -f ${LOCAL_CA}'/'${CA_CRT_FILE} ]; then
    mkdir -p ${LOCAL_CA}
    cp -v ${CA_CRT} ${LOCAL_CA}
else
    echo '>> CA certificate '${CA_CRT_FILE}' already published to local.'
fi

if [ ! host_setup ]; then
    echo ">> Starting with existing certificates."
    echo ">> CA certificate:"
    openssl x509 -in ${CA_CRT} -text -noout
    echo ">> Certificate:"
    openssl x509 -in ${CRT} -text -noout
fi

chown ${LOCAL_USER}.${LOCAL_GROUP} -R ${CERTS_FOLDER}
chown ${LOCAL_USER}.${LOCAL_GROUP} -R ${CA_FOLDER}

exec "$@"
