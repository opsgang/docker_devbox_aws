#!/bin/sh
_A=/assets
_B=/usr/local/bin
_S=/assets/alpine_build_scripts

echo "INFO ... creating skel bashrc"
cp -a ${_A}/fs/* /

echo "INFO ... installing terraform / packer versions scripts"
for a in terraform packer; do
    cp ${_S}/install_${a}.sh ${_B}/${a}_versions
    chmod a+x ${_B}/${a}_versions
done

echo "INFO: ... adding user skel files to homedir"
cp -a /etc/skel/. ~/

echo "INFO: ... installing docker engine"
apk --no-cache add --update docker || exit 1

rm -rf ${_A} 2>/dev/null

unset a _A _B _S
