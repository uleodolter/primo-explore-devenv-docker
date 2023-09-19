#!/usr/bin/env bash
set -e

DEFAULT_USER=node
DEFAULT_UID=$(id -u $DEFAULT_USER)
DEFAULT_GID=$(id -g $DEFAULT_USER)

DEVENV_USER=devenv
DEVENV_UID=${DEVENV_UID:-$DEFAULT_UID}
DEVENV_GID=${DEVENV_GID:-$DEFAULT_GID}

if getent passwd $DEVENV_USER >/dev/null; then
    userdel --remove $DEVENV_USER
fi
if getent group $DEVENV_USER >/dev/null; then
    groupdel $DEVENV_USER
fi

if [[ "$DEVENV_GID" != "$DEFAULT_GID" ]]; then
    groupadd -g $DEVENV_GID $DEVENV_USER
fi

DEVENV_GROUP=$(getent group $DEVENV_GID | cut -d: -f1)

if [[ "$DEVENV_UID" != "$DEFAULT_UID" ]]; then
    useradd -m -s /bin/bash -u $DEVENV_UID -g $DEVENV_GROUP -c "Devenv User" $DEVENV_USER
fi

DEVENV_USER=$(getent passwd $DEVENV_UID | cut -d: -f1)

# allow creation of files and directories
chgrp $DEVENV_GROUP . node_modules
chmod 775 . node_modules

# Alpine
if which su-exec >/dev/null; then
    exec su-exec $DEVENV_UID:$DEVENV_GID "$@"
fi

# Debian
if which gosu >/dev/null; then
    exec gosu "$DEVENV_USER" "$@"
fi
