#!/bin/sh
_A=/assets
_B=/usr/local/bin
_S=/alpine_build_scripts

echo "INFO ... creating skel bashrc"
cp -a ${_A}/fs/* /

echo "INFO ... installing vim"
${_S}/install_vim.sh || exit 1

echo "INFO ... installing awscli"
${_S}/install_awscli.sh || exit 1

echo "INFO ... installing credstash"
${_S}/install_credstash.sh || exit 1

echo "INFO ... installing packer"
for a in terraform packer; do
    cp ${_S}/install_${a}.sh ${_B}/${a}_versions
    chmod a+x ${_B}/${_a}_versions
done

echo "INFO ... installing popular GNU tools"
${_S}/install_essentials.sh || exit 1

echo ". /etc/bashrc" >> ~/.bashrc

apk --no-cache add --update docker || exit 1

rm -rf ${_S} ${_A} 2>/dev/null

unset a _A _B _S
