# Original from /etc/skel/
#
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

forwardSsh_help() {

    cat <<EOM
usage:  forwardSsh
... adds all of your .ssh keys to an ssh-agent for the current shell
EOM

}

forwardSsh() {

    [[ "$1" =~ ^\-h$|\-\-help$ ]] && forwardSsh_help && return 0
    [[ ! -z "$@" ]] && echo "... ignoring arguments $*"

    echo "... generating agent for ssh forwarding in cluster"
    pkill ssh-agent
    eval $(ssh-agent)
    for privateKey in $(ls -1 $HOME/.ssh/id_* | grep -v '\.pub')
    do
        ssh-add "$privateKey"
    done
    ssh-add -l # verify your key has been added to the key-ring
}

for script in /etc/profile.d/*.sh ; do
    [[ -r $script ]] && . $script
done

if [[ -d ~/profile.d ]]; then
    for f in ~/profile.d/*; do
        [[ -f $f ]] && echo "... sourcing $f" && . $f
        [[ $? -ne 0 ]] && echo "ERROR: ... could not source $f"
    done
fi

alias gtree='tree -a -C -I .git'
