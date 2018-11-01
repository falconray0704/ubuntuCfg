#!/bin/bash

set -o nounset
set -o errexit

set +x

export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/fabric-ca/clients/admin
fabric-ca-client register --id.name peer1 --id.type peer --id.affiliation org1.department1 --id.secret peer1pw
fabric-ca-client register --id.name peer2 --id.type peer --id.affiliation org1.department2 --id.secret peer2pw

set -x

