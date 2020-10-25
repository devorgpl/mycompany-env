#!/bin/bash
# Note: require DEV_DOCKER_USER to be set for remote and ssh-copy-key on dev server
# param - dev server host name

# DEV_DOCKER_USER=???
DEV_SERVER_ADDRESS=$1
echo ${DEV_SERVER_ADDRESS}

DOCKER_HOST="ssh://${DEV_DOCKER_USER}@${DEV_SERVER_ADDRESS}" docker-compose build
