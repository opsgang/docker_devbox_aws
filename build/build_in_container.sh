#!/bin/sh
DEV_PKGS="
    docker-cli
    su-exec
    gnupg
"

COMPLETION_PKGS="
    bash-completion
    git-bash-completion
    docker-bash-completion
"

echo "INFO ... creating skel bashrc"
cp -a /build/fs/* /

echo "INFO: ... adding user skel files to homedir"
cp -a /etc/skel/. ~/

echo "INFO: ... installing" ${DEV_PKGS}
apk --no-cache add --update ${DEV_PKGS} || exit 1

echo "INFO: ... adding " ${COMPLETION_PKGS}
apk --no-cache add --update ${COMPLETION_PKGS} || exit 1

echo "WARNING: setuid on su-exec lets any container user run as superuser"
chmod u+s /sbin/su-exec
