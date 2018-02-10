#!/bin/bash

usage() {
    echo "Usage: ./get-stats.sh ORGANIZATION GITHUB_TOKEN"
    echo
    echo "  -h      Display this message and exit"
}

if [ $# -lt 2 ]; then
    usage
    exit 0
fi

ORGANIZATION=$1
GITHUB_TOKEN=$2
curl -H "Authorization: token ${GITHUB_TOKEN}" http://127.0.0.1:3000/languages\?format\=json\&organization\=${ORGANIZATION} > ${ORGANIZATION}-stats.json