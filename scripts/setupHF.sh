#!/usr/bin/env bash

	echo "setup hyperledger fabric & fabric-ca & fabric-sdk-go & external libs"
	
    echo "setup fabric to version v1.0.0-rc1"
	mkdir -p $GOPATH/src/github.com/hyperledger
	cd $GOPATH/src/github.com/hyperledger && git clone https://github.com/hyperledger/fabric.git && cd fabric && git checkout v1.0.0-rc1
	echo "setup fabric-ca to version v1.0.0-rc1"
	cd $GOPATH/src/github.com/hyperledger && git clone https://github.com/hyperledger/fabric-ca.git && cd fabric-ca && git checkout v1.0.0-rc1
		
    echo "setup fabric-sdk-go to commit 85fa3101eb4694d464003c3a900672d632f17833"
	cd $GOPATH/src/github.com/hyperledger && git clone https://github.com/hyperledger/fabric-sdk-go.git && cd fabric-sdk-go && git checkout 85fa3101eb4694d464003c3a900672d632f17833
	
    echo "installing fabric & fabric-ca packages"
	sudo apt install libltdl-dev
	go get github.com/hyperledger/fabric-sdk-go/pkg/fabric-client
	go get github.com/hyperledger/fabric-sdk-go/pkg/fabric-ca-client
	
    echo "installing fabric-sdk-go dependencies"
	cd $GOPATH/src/github.com/hyperledger/fabric-sdk-go && make
	
    echo "fabric & fabric-ca & fabric-sdk-go setup done"
	
    echo "setup external libs"
	go get -u github.com/kardianos/govendor
	cd $GOPATH/src/github.com/noursaadallah/kidner && govendor init && govendor add +external