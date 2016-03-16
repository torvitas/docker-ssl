#!/bin/bash

export CA_KEY=${CA_KEY:-'/usr/local/etc/ssl/ca/root.key'}
export CA_CRT=${CA_CRT:-'/usr/local/etc/ssl/ca/root.crt'}

export CA_CN=${CA_CN:-'*.localhost'}
export CA_OU=${CA_OU:-'A Company that Makes Everything'}
export CA_O=${CA_O:-'ACME'}

export KEY=${KEY:-'/usr/local/etc/ssl/certs/host.key'}
export CSR=${CSR:-'/usr/local/etc/ssl/certs/host.csr'}
export CRT=${CRT:-'/usr/local/etc/ssl/certs/host.crt'}

export DNS=${DNS:-'*.localhost'}

export CN=${CN:-'*.localhost'}
export OU=${OU:-'A Company that Makes Everything'}
export O=${O:-'ACME'}
