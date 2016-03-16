#!/bin/bash

function buildVariableName()
{
    echo "DNS_${1}"
}

function getAlternativeNames()
{
    i=0
    name="$(buildVariableName ${i})"
    while [ ${!name} ]; do
        result="${result}DNS.${i}=${!name}\n"
        let i=i+1
        name=$(buildVariableName ${i})
    done
    echo ${result}
}
