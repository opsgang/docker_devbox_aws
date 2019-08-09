[1]: https://github.com/opsgang/docker_aws_env "opsgang/aws_env"
[2]: https://terraform.io "Hashicorp Terraform"
[3]: https://packer.io "Hashicorp Packer"
# docker\_devbox\_aws
> 
> [aws\_env][1] with additional tools for
> running docker from the host, bash completions
> using personal aws creds, ssh keys and gnupg.
>
> Plus vim.

## featuring ...

* the [opsgang/aws\_env tools][1]

* docker cli (useful if you mount the docker.sock from the host)

* commands to manage multiple versions of [terraform][2] or [packer][3]

* su-exec

## labels

The docker image contains audit info (use _docker inspect_ to see) including version info about
key tools e.g. docker, jq, awscli, as well as git build info.

## skel dirs

The following assets if mounted in the container under /etc/skel will be copied
to your container user's home dir as well when you invoke /bin/bash as a login shell:

* .aws/      e.g. `-v $HOME/.aws:/etc/skel/.aws`

* .ssh/      e.g. `-v $HOME/.ssh:/etc/skel/.ssh`

* .gnupg/    e.g. `-v $HOME/.gnupg:/etc/skel/.gnupg`

* .gitconfig e.g. `-v $HOME/.gitconfig:/etc/skel/.gitconfig`

## ENTRYPOINT

/docker-entrypoint.sh script in container.

If you are using `docker run`'s `--user` option, this creates you a 'real' OS user
and home dir seeded from /etc/skel, with the provided uid.

**We do nothing special with any gid passed via the --user option**

It also ensures that things like docker are usable by your non-root user.

## CONFIG WHEN USING docker --user

*DEVBOX_USER*: name for your user's uid in the container

*DEVBOX_HOME*: path in container for your user's home dir

## building

**master branch built at shippable.com**

[![Run Status](https://api.shippable.com/projects/58ed13f25a50220700d3c595/badge?branch=master)](https://api.shippable.com/projects/58ed13f25a50220700d3c595)

```bash
git clone https://github.com/opsgang/docker_devbox_aws.git
cd docker_devbox_aws
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

