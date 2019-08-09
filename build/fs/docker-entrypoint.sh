#!/bin/bash
# vim: et sr sw=4 ts=4 smartindent:
#
# runtime modifications to preserve work env:
# * container user has an associated home dir with skel files copied over
# * ensure that container user at can access host's docker.sock
#
devbox_user="${DEVBOX_USER:-me}"
devbox_home="${DEVBOX_HOME:-/home/$devbox_user}"
uid=$(id -u)

# ... check if virtual user created via docker --user opt
real_user= ; whoami $uid &>/dev/null && real_user="true"

if [[ ! "$real_user" ]]; then
    # ... create home dir if needed
    su-exec root adduser -h "$devbox_home" -D -u $uid $devbox_user
    export HOME="$devbox_home"
fi

[[ -e "/var/run/docker.sock" ]] && su-exec root chown $uid /var/run/docker.sock

exec $@
