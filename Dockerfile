# vim: et sr sw=4 ts=4 smartindent syntax=dockerfile:
FROM opsgang/aws_env:2

LABEL \
      name="opsgang/devbox_aws" \
      vendor="sortuniq" \
      description=" \
... a workspace with dev tools for: \
- aws api \
- docker (engine installed); \
- bash, python, git, jq, make, ssh, curl, vim \
- cmds to install and manage terraform and packer versions \
"

COPY build /build/

RUN sh /build/install_vim.sh
RUN /build/build_in_container.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]

# built with additional labels:
#
# opsgang.build_git_uri
# opsgang.build_git_sha
# opsgang.build_git_branch
# opsgang.build_git_tag
# opsgang.built_by
#
