#!/usr/bin/env bash
echo 'Usage : '
echo
echo 'make setup-preq	install latest version of Docker and docker-compose and install go v1.8.3'
echo '				(you need to logout/login after this step for the changes to take effect'
echo
echo 'make setup-hf	install hyperledger fabric, fabric-ca, and fabric-sdk-go ; set them to the required versions and install external libs'
echo
echo 'make all	clean the environment, build the app, start environment and run'
echo
echo 'make dev	build and run the app'
echo
echo 'make build	build the app'
echo
echo 'make run	run the app'
echo
echo 'make clean	clean-up temporary files and docker images'
echo
echo 'make env-up	start the necessary docker images'
echo
echo 'make env-down	stop the running docker images' 
echo	