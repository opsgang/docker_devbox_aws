# Original from /etc/skel/
#
export PATH=/usr/local/terraform/bin:/usr/local/packer/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

_print_helpers() {

    # ... funcs: (non _help ones)
    local f=$(declare -f | grep -Po '^(\w+)(?= \(\))' | grep -v '_help$')

    # ... funcs for which a _help func exists
    local fh=$(declare -f | grep -Po '^(\w+)(?=_help \(\))') # funcs that have help

    local func_list=$(comm -1 <(echo "$f") <(echo "$fh"))

    # ... find longest name, for prettier formatting
    local length_name=$(
        echo "$func_list"                                   \
        | awk '{ print length()+2 | "sort -nr | head -1" }'
    )

    echo "SHELL FUNCTIONS: "
    # ... print helper info
    # ... provide default helper info if not defined.
    local help_txt="usage: ... no help information provided. That sucks."
    local func
    for func in $func_list; do
        if ! set | grep "^${func}_help ()" >/dev/null 2>&1
        then
            eval "function ${func}_help(){ echo \"$help_txt\"; }"
        fi
        _print_helper_msg "$func" "$length_name"
    done
}

_print_helper_msg() {
    local func="$1"
    local length_name="$2"
    local start_line="${func}()"
    local format_str line

    local oIFS=$IFS
    IFS=$'\n'

    for line in $(${func}_help); do
        # ... info lines in cyan 'cos its purrdy Mr. Taggart...
        if [[ $start_line =~ ^[\ ]$ ]]; then
            line="\e[2m\e[36m$line\e[0m\e[22m"
            format_str="%-${length_name}s $line\n"
        else
        # ... function names in green with emboldened usage info
            line="\e[1m$line\e[0m"
            format_str="\e[32m%-${length_name}s\e[0m $line\n"
        fi
        printf "$format_str" $start_line
        start_line=' ' # omit function name at start of subsequent lines
    done

    IFS=$oIFS
    echo ""
}

forwardSsh_help() {

    cat <<EOM
usage:  forwardSsh
... adds all of your .ssh keys to an ssh-agent for the current shell
EOM

}

forwardSsh() {

    [[ "$1" =~ ^\-h$|\-\-help$ ]] && forwardSsh_help && return 0
    [[ ! -z "$@" ]] && echo "... ignoring arguments $*"

    priv_keys=$(ls -1 ~/.ssh/id_* 2>/dev/null | grep -v '\.pub')

    [[ -z "$priv_keys" ]] && return 0

    echo "... generating agent for ssh forwarding in cluster"
    pkill ssh-agent
    eval $(ssh-agent)
    for privateKey in $priv_keys; do
        ssh-add "$privateKey"
    done
    ssh-add -l # verify your key has been added to the key-ring
}

sourceCompletions() {
    local c=""
    .  /usr/share/bash-completion/bash_completion
    for c in git docker make; do
        . /usr/share/bash-completion/completions/$c
    done
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

if [[ $- == *i* ]]; then
    _print_helpers
    forwardSsh
    sourceCompletions
fi
