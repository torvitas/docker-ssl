#!/bin/bash

export UNIQUE_CERT_NAME=${UNIQUE_CERT_NAME:-}

export CN=${CN:-'A Company that Makes Everything'}
export O=${O:-'ACME'}
export OU=${OU:-'Domain Control Validated'}

export LOCAL_CERTS=${LOCAL_CERTS:-'/local/certs'}
export LOCAL_CA=${LOCAL_CA:-'/local/ca'}
export CERTS_FOLDER=${CERTS_FOLDER:-'/usr/local/share/ca-certificates/certs'}
export CA_FOLDER=${CA_FOLDER:-'/usr/local/share/ca-certificates/ca'}

export CA_KEY_FILE=${CA_KEY_FILE:-${UNIQUE_CERT_NAME}'cakey.pem'}
export CA_CRT_FILE=${CA_CRT_FILE:-${UNIQUE_CERT_NAME}'cacrt.pem'}

export CA_KEY=${CA_KEY:-${CA_FOLDER}'/'${CA_KEY_FILE}}
export CA_CRT=${CA_CRT:-${CA_FOLDER}'/'${CA_CRT_FILE}}

export CA_CN=${CA_CN:-'A Company that Validates Everything'}
export CA_O=${CA_O:-'ACVE'}
export CA_OU=${CA_OU:-'Validations for everything'}

export KEY_FILE=${KEY_FILE:-${UNIQUE_CERT_NAME}'.key'}
export CRT_FILE=${CRT_FILE:-${UNIQUE_CERT_NAME}'.crt'}
export CSR_FILE=${CSR_FILE:-${UNIQUE_CERT_NAME}'.csr'}

export KEY=${KEY:-${CERTS_FOLDER}'/'${KEY_FILE}}
export CSR=${CSR:-${CERTS_FOLDER}'/'${CSR_FILE}}
export CRT=${CRT:-${CERTS_FOLDER}'/'${CRT_FILE}}

export LOCAL_USER=${LOCAL_USER:-'1000'}
export LOCAL_GROUP=${LOCAL_GROUP:-'1000'}
