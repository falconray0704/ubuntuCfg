#!/bin/bash

set -o nounset
set -o errexit

set +x

export SERVER_CA="172.16.255.130"

export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/fabric-ca/clients/peer1
fabric-ca-client enroll -u http://peer1:peer1pw@$SERVER_CA:7054 -M $FABRIC_CA_CLIENT_HOME/msp

export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/fabric-ca/clients/peer2
fabric-ca-client enroll -u http://peer2:peer2pw@$SERVER_CA:7054 -M $FABRIC_CA_CLIENT_HOME/msp

set -x

