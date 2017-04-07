[1]: http://docs.aws.amazon.com/cli/latest/reference "use aws apis from cmd line"
[2]: https://github.com/fugue/credstash "credstash - store and retrieve secrets in aws"
[3]: https://github.com/opsgang/alpine_build_scripts/blob/master/install_essentials.sh "common GNU tools useful for automation"
# docker\_devbox_aws
_... defines an **alpine linux** container providing an env to run bash or_
_python scripts, that need docker, awscli, credstash, curl and / or jq._

## featuring ...

* [aws cli] [1]

* [credstash] [2] (for managing secrets in aws)

* docker engine

* bash, python, curl, git, make, jq, openssh client [and friends] [3]

## building

**master branch built at shippable.com**

[![Run Status](https://api.shippable.com/projects/589464f08d80360f008b754e/badge?branch=master)](https://app.shippable.com/projects/589464f08d80360f008b754e)

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
