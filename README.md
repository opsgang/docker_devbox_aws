[1]: http://docs.aws.amazon.com/cli/latest/reference "use aws apis from cmd line"
[2]: https://github.com/fugue/credstash "credstash - store and retrieve secrets in aws"
[3]: https://github.com/opsgang/alpine_build_scripts/blob/master/install_essentials.sh "common GNU tools useful for automation"
[4]: https://terraform.io "Hashicorp Terraform"
[5]: https://packer.io "Hashicorp Packer"
# docker_devbox_aws
_... alpine workspace with dev tools for aws api, credstash, docker, bash, python, git, jq, make, ssh, curl, vim ..._

## featuring ...

* [aws cli] [1]

* [credstash] [2] (for managing secrets in aws)

* docker engine

* bash, python, curl, git, make, jq, openssh client [and friends] [3]

* scripts to install multiple versions of [terraform] [4] or [packer] [5]

## building

**master branch built at shippable.com**

[![Run Status](https://api.shippable.com/projects/58ed13f25a50220700d3c595/badge?branch=master)](https://api.shippable.com/projects/58ed13f25a50220700d3c595/badge?branch=master)

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
# run an ephemeral workspace, mounting your .aws dir and the docker daemon from the host
docker run -it \
    -v ~/.aws:~/.aws \
    -v /var/run/docker.sock:/var/run/docker.sock \
        opsgang/devbox_aws:stable /bin/bash

# At shell in container, do what you want ... e.g. install terraform
> terraform_versions 0.9.2
```

```bash
# run a custom script /path/to/script.sh that uses aws cli, curl, jq blah ...
docker run --rm -i -v /path/to/script.sh:/script.sh:ro opsgang/devbox_aws:stable /script.sh
```

```bash
# make my aws creds available and run /some/python/script.py
export AWS_ACCESS_KEY_ID="i'll-never-tell" # replace glibness with your access key
export AWS_SECRET_ACCESS_KEY="that's-for-me-to-know" # amend as necessary

docker run --rm -i                      \ # ... run interactive to see stdout / stderr
    -v /some/python/script.py:/my.py:ro \ # ... assume the file is executable
    --env AWS_ACCESS_KEY_ID             \ # ... will read it from your env
    --env AWS_SECRET_ACCESS_KEY         \ # ... will read it from your env
    --env AWS_DEFAULT_REGION=eu-west-2  \ # ... adjust geography to taste
    opsgang/devbox_aws:stable /my.py         # script can access these env vars
```
