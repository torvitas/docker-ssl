#!/bin/bash

export DNS=${DNS:-'*.localhost'}

export CN=${CN:-'*.localhost'}
export OU=${OU:-'A Company that Makes Everything'}
export O=${O:-'ACME'}

export PROXY_CERTS=${PROXY_CERTS:-'/proxy/certs/'}
export CERTS_FOLDER=${CERTS_FOLDER:-'/usr/local/etc/ssl/certs/'}
export CA_FOLDER=${CA_FOLDER:-'/usr/local/etc/ssl/ca/'}

export CA_KEY_FILE=${CA_KEY_FILE:-'root.key'}
export CA_CRT_FILE=${CA_CRT_FILE:-'root.crt'}

export CA_KEY=${CA_KEY:-${CA_FOLDER}${CA_KEY_FILE}}
export CA_CRT=${CA_CRT:-${CA_FOLDER}${CA_CRT_FILE}}

export CA_CN=${CA_CN:-'*.localhost'}
export CA_OU=${CA_OU:-'A Company that Makes Everything'}
export CA_O=${CA_O:-'ACME'}

export KEY_FILE=${KEY_FILE:-'host.key'}
export CSR_FILE=${CSR_FILE:-'host.csr'}
export CRT_FILE=${CRT_FILE:-'host.crt'}

export KEY=${KEY:-${CERTS_FOLDER}${KEY_FILE}}
export CSR=${CSR:-${CERTS_FOLDER}${CSR_FILE}}
export CRT=${CRT:-${CERTS_FOLDER}${CRT_FILE}}
