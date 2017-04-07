# vim: et sr sw=4 ts=4 smartindent syntax=dockerfile:
FROM gliderlabs/alpine:3.4

MAINTAINER jinal--shah <jnshah@gmail.com>
LABEL \
      name="opsgang/devbox_aws" \
      vendor="sortuniq" \
      description=" \
... a workspace with dev tools for: \
- aws api (and credstash for secrets; \
- docker (engine installed); \
- bash, python, git, jq, make, ssh, curl, vim \
"

COPY alpine_build_scripts /alpine_build_scripts
COPY assets /assets

RUN sh /alpine_build_scripts/install_vim.sh           \
    && sh /alpine_build_scripts/install_awscli.sh     \
    && sh /alpine_build_scripts/install_credstash.sh  \
    && sh /alpine_build_scripts/install_essentials.sh \
    && apk --no-cache add --update docker             \
    && rm -rf /alpine_build_scripts /assets 2>/dev/null

CMD ["/bin/bash"]

# built with additional labels:
#
# version
# opsgang.awscli_version
# opsgang.credstash_version
# opsgang.docker_version
# opsgang.jq_version
#
# opsgang.build_git_uri
# opsgang.build_git_sha
# opsgang.build_git_branch
# opsgang.build_git_tag
# opsgang.built_by
#
