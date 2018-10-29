Redmine image for Docker
========================

Redmine image for Docker with RAILS_RELATIVE_URL_ROOT patch and
git-remote plugin.

This Redmine image is based on the [official -/redmine image][1] and
extended by a patch to correctly use the RAILS_RELATIVE_URL_ROOT
environment variable and with an installed [git-remote][2] plugin.

[1]: https://hub.docker.com/_/redmine
[2]: https://github.com/dergachev/redmine_git_remote
