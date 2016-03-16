#!/bin/bash

# prepare environment
. /usr/local/lib/ssl/entrypoint.environment.sh
. /usr/local/lib/ssl/entrypoint.functions.sh
. /usr/local/lib/ssl/template.renderer.sh

# make sure there the specified ca exists
if [ ! -f ${CA_KEY} ]; then
    openssl genrsa -out ${CA_KEY} 2048
    render /usr/local/etc/ssl/template/root.cnf.template -- > /usr/local/etc/ssl/rootssl.conf
    openssl req -x509 -new -nodes -key ${CA_KEY} -out ${CA_CRT} -config /usr/local/etc/ssl/rootssl.conf
else
    echo '>> Using existing CA.'
fi

if [ ! -f ${KEY} ]; then
    openssl genrsa -out ${KEY} 2048
    render /usr/local/etc/ssl/template/host.cnf.template -- > /usr/local/etc/ssl/hostssl.conf
    openssl req -new -nodes -key ${KEY} -out ${CSR} -config /usr/local/etc/ssl/hostssl.conf
    openssl x509 -req -in ${CSR} -CA ${CA_CRT} -CAkey ${CA_KEY} -CAcreateserial -out ${CRT} -days 365
else
    echo '>> Using existing certificate, doing nothing.'
fi

echo ">> CSR:"
openssl req -in ${CSR} -noout -text
echo ">> CRT:"
cat ${CRT}

exec "$@"
