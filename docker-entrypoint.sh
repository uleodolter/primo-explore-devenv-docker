#!/usr/bin/env bash
set -e

DEFAULT_USER=node
DEFAULT_UID=$(id -u $DEFAULT_USER)
DEFAULT_GID=$(id -g $DEFAULT_USER)

DOCKER_UID=${DOCKER_UID:-$DEFAULT_UID}
DOCKER_GID=${DOCKER_GID:-$DEFAULT_GID}

if [[ "$DOCKER_GID" != "$DEFAULT_GID" ]]; then
    addgroup -g $DOCKER_GID docker
fi

if [[ "$DOCKER_UID" != "$DEFAULT_UID" ]]; then
    DOCKER_GROUP=$(getent group $DOCKER_GID | cut -d: -f1)
    adduser -G $DOCKER_GROUP -s /bin/bash -u $DOCKER_UID -g "Docker User" -D docker
fi

# allow creation of files and directories
chgrp $DOCKER_GROUP .
chmod 775 .

exec su-exec $DOCKER_UID:$DOCKER_GID "$@"
