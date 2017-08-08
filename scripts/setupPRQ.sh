#!/usr/bin/env bash

	echo "Setting up the technologies required ..."
	
    echo "installing docker ..."
	sudo apt install docker.io
	
    echo "installing docker compose ..."
	sudo apt install docker-compose
	
    echo "configure docker user to current user"
	sudo groupadd docker
	sudo gpasswd -a ${USER} docker
	sudo service docker restart
	
    echo "install Go 1.8.3 and set the GOPATH to $HOME/go"
	wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz
	rm go1.8.3.linux-amd64.tar.gz
	echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
	echo 'export GOPATH=$HOME/go' | tee -a $HOME/.bashrc
	echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' | tee -a $HOME/.bashrc
	mkdir -p $HOME/go/{src,pkg,bin}
	echo "please login and logout for the changes to take effect"