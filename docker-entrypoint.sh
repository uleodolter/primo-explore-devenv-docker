#!/usr/bin/env bash
set -e

DEFAULT_USER=node
DEFAULT_UID=$(id -u $DEFAULT_USER)
DEFAULT_GID=$(id -g $DEFAULT_USER)

DOCKER_UID=${UID:-$DEFAULT_UID}
DOCKER_GID=${GID:-$DEFAULT_GID}

if [[ "$DOCKER_UID" != "$DEFAULT_UID" ]]; then
    usermod -o -u $DOCKER_UID $DEFAULT_USER
fi

if [[ "$DOCKER_GID" != "$DEFAULT_GID" ]]; then
    groupmod -o -g $DOCKER_GID $DEFAULT_USER
fi

exec su-exec $DOCKER_UID:$DOCKER_GID "$@"
