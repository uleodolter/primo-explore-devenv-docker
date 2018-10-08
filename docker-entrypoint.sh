#!/usr/bin/env bash
set -e

DEFAULT_USER=node
DEFAULT_UID=$(id -u $DEFAULT_USER)
DEFAULT_GID=$(id -g $DEFAULT_USER)

DOCKER_UID=${DOCKER_UID:-$DEFAULT_UID}
DOCKER_GID=${DOCKER_GID:-$DEFAULT_GID}

if [[ "$DOCKER_GID" != "$DEFAULT_GID" ]]; then
    if getent group docker >/dev/null; then
        delgroup docker
    fi
    addgroup -g $DOCKER_GID docker
fi

DOCKER_GROUP=$(getent group $DOCKER_GID | cut -d: -f1)

if [[ "$DOCKER_UID" != "$DEFAULT_UID" ]]; then
    if getent passwd docker >/dev/null; then
        deluser --remove-home docker
    fi
    adduser -G $DOCKER_GROUP -s /bin/bash -u $DOCKER_UID -g "Docker User" -D docker
fi

DOCKER_USER=$(getent passwd $DOCKER_UID | cut -d: -f1)

# allow creation of files and directories
chgrp $DOCKER_GROUP . node_modules
chmod 775 . node_modules

exec su-exec $DOCKER_UID:$DOCKER_GID "$@"
