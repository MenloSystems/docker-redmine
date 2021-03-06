Redmine image for Docker
========================

Redmine image for Docker with several extensions and improvements.

This Redmine image is based on the [official -/redmine image][1] plus a
RAILS_RELATIVE_URL_ROOT patch, support for additional SSL certificates,
public custom_fields and pre-installed plugins:

* git-remote
* scm-hookhelpers

RAILS_RELATIVE_URL_ROOT patch
-----------------------------

Supports shifting the complete Redmine instance into a subdirectory by
defining an environment variable
`RAILS_RELATIVE_URL_ROOT=/sub/url/to/redmine`. If the variable is
missing, Redmine is served from the base URL.

Additional SSL certificates
---------------------------

Any certificates present in the `/usr/local/share/ca-certificates/`
directory are added to the list of CAs trusted by OpenSSL on start of
the container.

Public custom_fields
--------------------

The /custom_fields API endpoint is now readable for everyone. Only
modification requires admin privileges.

git-remote plugin
-----------------

Comes with the [git-remote][2] plugin pre-installed.

scm-hookhelpers plugin
----------------------

Comes with the [scm-hookhelpers][3] plugin pre-installed.

[1]: https://hub.docker.com/_/redmine
[2]: https://github.com/dergachev/redmine_git_remote
[3]: https://github.com/lpirl/redmine_scm_hookhelpers
