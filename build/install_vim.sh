#!/bin/sh
# install_vim.sh
# suitable for apk pkg
# - adds pathogen for all users
# - makes comments readable
# - adds my preferred indentation defaults
VIM_INDENT=4
VIMRC=/etc/vim/vimrc

PKGS="vim"
REQ_PKGS="curl ca-certificates git"

# ... only install if not already installed.
for p in $REQ_PKGS; do
    if ! apk info | grep "^${p}$" >/dev/null 2>&1
    then
        BUILD_PKGS="$BUILD_PKGS $p"
    fi
done

echo "INFO $0: installing $PKGS pathogen"
apk --no-cache add --update $PKGS $BUILD_PKGS \
&& mkdir -p /etc/vim/autoload /etc/vim/bundle \
&& curl -LSso /etc/vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

if [[ ! -r /etc/vim/autoload/pathogen.vim ]]; then
    echo "ERROR: $0: failed to get pathogen (vim plugin manager)"
fi

# ... we want modelines dammit ...
sed -i 's/^\(set nomodeline\)/" \1/' $VIMRC

cat << EOF >> $VIMRC
" added by $0 $(date +'%Y-%m-%d %H:%M:%S')
set rtp+=/etc/vim
execute pathogen#infect()
hi Comment ctermfg=6
set tabstop=$VIM_INDENT
set shiftwidth=$VIM_INDENT
set shiftround
set expandtab
set smartindent
set pastetoggle=<F1>
autocmd FileType make setlocal noexpandtab
autocmd FileType go setlocal noexpandtab
EOF

cp $VIMRC $HOME/.vimrc 2>/dev/null

[[ -d /etc/skel ]] && cp $VIMRC /etc/skel/.vimrc

# ... delete newly installed pkgs required just for this build
if [[ ! -z $(echo "$BUILD_PKGS" | sed -e 's/ //g') ]] ; then
    echo "INFO $0: deleting helper pkgs"
    apk --no-cache --purge del $BUILD_PKGS
fi
rm -rf /var/cache/apk/*

exit 0

