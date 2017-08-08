.PHONY: all dev clean build env-up env-down run

all: clean build env-up run

dev: build run

##### BUILD
build:
	@sh ./scripts/build.sh

##### ENV
env-up:
	@sh ./scripts/env_up.sh

env-down:
	@sh ./scripts/env_down.sh

##### RUN
run:
	@echo "Start app ..."
	@./kidner

##### CLEAN
clean: env-down
	@sh ./scripts/clean.sh

#### init the prerequisites
setup-preq:
	@sh ./scripts/setupPRQ.sh

#### init the setup : hyperledger fabric & fabric-ca & fabric-sdk-go
setup-hf:
	@sh ./scripts/setupHF.sh

#### help
help:
	@chmod a+x ./scripts/*
	@sh ./scripts/help.sh