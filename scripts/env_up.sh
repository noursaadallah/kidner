#!/usr/bin/env bash

    echo "Start environment ..."
	cd fixtures && docker-compose up --force-recreate -d
	echo "Sleep 15 seconds in order to let the environment setup correctly"
	sleep 15
	echo "Environment up"