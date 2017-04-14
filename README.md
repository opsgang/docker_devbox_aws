[1]: http://docs.aws.amazon.com/cli/latest/reference "use aws apis from cmd line"
[2]: https://github.com/fugue/credstash "credstash - store and retrieve secrets in aws"
[3]: https://github.com/opsgang/alpine_build_scripts/blob/master/install_essentials.sh "common GNU tools useful for automation"
[4]: https://terraform.io "Hashicorp Terraform"
[5]: https://packer.io "Hashicorp Packer"
# docker_devbox_aws
_... alpine workspace with dev tools for aws api, credstash, docker, bash, python, git, jq, make, ssh, curl, vim ..._

## featuring ...

* [aws cli][1]

* [credstash][2] (for managing secrets in aws)

* docker engine

* bash, python, vim, curl, git, make, jq, openssh client [and friends][3]

* scripts to install multiple versions of [terraform][4] or [packer][5]

## labels

The docker image contains audit info (use _docker inspect_ to see) including version info about
key tools e.g. docker, jq, awscli, as well as git build info.

## skel dirs

The following assets if mounted under /etc/skel will be copied to your container user's home dir as well
when you invoke /bin/bash as a login shell:

* .aws dir

* .ssh dir

* .gitconfig file

If you create a new user in the container from this image (or a derived FROM image) the new user will
also get these copied over to their home.

## building

**master branch built at shippable.com**

[![Run Status](https://api.shippable.com/projects/58ed13f25a50220700d3c595/badge?branch=master)](https://api.shippable.com/projects/58ed13f25a50220700d3c595)

```bash
git clone https://github.com/opsgang/docker_devbox_aws.git
cd docker_devbox_aws
git clone https://github.com/opsgang/alpine_build_scripts
./build.sh # adds custom labels to image
```

## installing

```bash
docker pull opsgang/devbox_aws:stable # or use the tag you prefer
```

## running

```bash
# ... run an ephemeral workspace, mounting your .aws,.ssh and .gitconfig, and the docker daemon from the host
docker run -it --user root
    -v $HOME/.aws:/etc/skel/.aws \
    -v $HOME/.ssh:/etc/skel/.ssh \
    -v $HOME/.gitconfig:/etc/skel/.gitconfig \
    -v /var/run/docker.sock:/var/run/docker.sock \
        opsgang/devbox_aws:stable /bin/bash

# At shell in container, do what you want ... e.g. install terraform
> terraform_versions 0.9.2
```

```bash
# run a custom script /path/to/script.sh that uses aws cli, curl, jq blah ...
docker run --rm -i -v /path/to/script.sh:/script.sh:ro opsgang/devbox_aws:stable /script.sh
```

