# vim: et sr sw=4 ts=4 smartindent syntax=dockerfile:
FROM opsgang/aws_env:stable

LABEL \
      name="opsgang/devbox_aws" \
      vendor="sortuniq" \
      description=" \
... a workspace with dev tools for: \
- aws api and credstash for secrets; \
- docker (engine installed); \
- bash, python, git, jq, make, ssh, curl, vim \
- cmds to manage terraform, packer versions \
"

COPY assets /assets

RUN sh /assets/build.sh

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
