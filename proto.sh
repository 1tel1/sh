#!/usr/bin/env bash
cd /usr/locaL/xswitch*
git clone https://git.xswitch.cn/xswitch/xctrl.git
cd xctrl
go install github.com/chuanlinzhang/protoc-gen-doc/cmd/protoc-gen-doc@v0.0.2
make proto
make java
make doc-md
make doc-html
go run main.go
make test
