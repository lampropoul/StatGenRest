#!/bin/bash

usage() {
    echo "Usage: ./get-stats.sh ORGANIZATION"
    echo
    echo "  -h      Display this message and exit"
}

if [ $# -eq 0 ]
  then
    usage
    exit 0
fi

ORGANIZATION=$1
curl http://127.0.0.1:3000/languages\?format\=json\&organization\=${ORGANIZATION} > ${ORGANIZATION}-stats.json