.PHONY: all dev clean build env-up env-down run

all: clean build env-up run

dev: build run

##### BUILD
build:
	@echo "Build ..."
	@govendor sync
	@go build
	@echo "Build done"

##### ENV
env-up:
	@echo "Start environment ..."
	@cd fixtures && docker-compose up --force-recreate -d
	@echo "Sleep 15 seconds in order to let the environment setup correctly"
	@sleep 15
	@echo "Environment up"

env-down:
	@echo "Stop environnement ..."
	@cd fixtures && docker-compose down
	@echo "Environnement down"

##### RUN
run:
	@echo "Start app ..."
	@./kidner

##### CLEAN
clean: env-down
	@echo "Clean up ..."
	@rm -rf /tmp/enroll_user /tmp/msp kidner
	@docker rm -f -v `docker ps -a --no-trunc | grep "kidner" | cut -d ' ' -f 1` 2>/dev/null || true
	@docker rmi `docker images --no-trunc | grep "kidner" | cut -d ' ' -f 1` 2>/dev/null || true
	@echo "Clean up done"

#### init the prerequisites
setup-preq:
	@echo "Setting up the technologies required ..."
	
	@echo "installing docker ..."
	@sudo apt install docker.io

	@echo "installing docker compose ..."
	@sudo apt install docker-compose

	@echo "configure docker user to current user"
	@sudo groupadd docker
	@sudo gpasswd -a ${USER} docker
	@sudo service docker restart

	@echo "install Go 1.8.3 and set the GOPATH to $HOME/go"
	@wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
	@sudo tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz
	@rm go1.8.3.linux-amd64.tar.gz
	@echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
	@echo 'export GOPATH=$HOME/go' | tee -a $HOME/.bashrc
	@echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' | tee -a $HOME/.bashrc
	@mkdir -p $HOME/go/{src,pkg,bin}

	@echo "please login and logout for the changes to take effect"


#### init the setup : hyperledger fabric & fabric-ca & fabric-sdk-go
setup-hf:
	@echo "setup hyperledger fabric & fabric-ca & fabric-sdk-go & external libs"
	
	@echo "setup fabric to version v1.0.0-rc1"
	@mkdir -p $GOPATH/src/github.com/hyperledger
	@cd $GOPATH/src/github.com/hyperledger
	@git clone https://github.com/hyperledger/fabric.git
	@cd fabric
	@git checkout v1.0.0-rc1

	@echo "setup fabric-ca to version v1.0.0-rc1"
	@cd $GOPATH/src/github.com/hyperledger
	@git clone https://github.com/hyperledger/fabric-ca.git
	@cd fabric-ca
	@git checkout v1.0.0-rc1
	
	@echo "setup fabric-sdk-go to commit 85fa3101eb4694d464003c3a900672d632f17833"
	@cd $GOPATH/src/github.com/hyperledger
	@git clone https://github.com/hyperledger/fabric-sdk-go.git
	@cd fabric-sdk-go
	@git checkout 85fa3101eb4694d464003c3a900672d632f17833
	
	@echo "installing fabric & fabric-ca packages"
	@sudo apt install libltdl-dev
	@go get github.com/hyperledger/fabric-sdk-go/pkg/fabric-client
	@go get github.com/hyperledger/fabric-sdk-go/pkg/fabric-ca-client

	@echo "installing fabric-sdk-go dependencies"
	@cd $GOPATH/src/github.com/hyperledger/fabric-sdk-go && make

	@echo "fabric & fabric-ca & fabric-sdk-go setup done"

	@echo "setup external libs"
	@go get -u github.com/kardianos/govendor
	@cd $GOPATH/src/github.com/chainhero/heroes-service
	@govendor init && govendor add +external


#### help
help:
	@echo 'Usage : '
	@echo
	@echo 'make setup-preq	install latest version of Docker and docker-compose and install go v1.8.3'
	@echo '				(you need to logout/login after this step for the changes to take effect'
	@echo
	@echo 'make setup-hf	install hyperledger fabric, fabric-ca, and fabric-sdk-go ; set them to the required versions and install external libs'
	@echo
	@echo 'make all	clean the environment, build the app, start environment and run'
	@echo
	@echo 'make dev	build and run the app'
	@echo
	@echo 'make build	build the app'
	@echo
	@echo 'make run	run the app'
	@echo
	@echo 'make clean	clean-up temporary files and docker images'
	@echo
	@echo 'make env-up	start the necessary docker images'
	@echo
	@echo 'make env-down	stop the running docker images' 
	@echo	