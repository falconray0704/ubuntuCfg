#!/bin/bash

mkdir -p /opt/gows/src/github.com/xtaci/
cd /opt/gows/src/github.com/xtaci/
rm -rf kcptun

go get github.com/golang/snappy
go get github.com/xtaci/kcp-go
go get github.com/urfave/cli
go get github.com/xtaci/smux
go get golang.org/x/crypto/pbkdf2
go get github.com/pkg/errors

go get github.com/xtaci/kcptun

cd /opt/gows/src/github.com/xtaci/kcptun

./build-release.sh


