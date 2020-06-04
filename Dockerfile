FROM redmine AS orig
# This build stage is just a source for an unpatched file


FROM alpine AS build
# This build stage actually prepares all files

# Install git & patch tools and configure git
# Run `docker build --no-cache .` to update dependencies
RUN\
 apk add --no-cache git patch &&\
 git config --global advice.detachedHead false

# Set up work directory
WORKDIR /home
RUN mkdir -p usr/src/redmine/app/controllers usr/src/redmine/plugins

# Get the config.ru file and patch it
COPY --from=orig /usr/src/redmine/config.ru ./usr/src/redmine/
COPY relative_url_root.patch /tmp/
RUN patch -p1 </tmp/relative_url_root.patch

# Get the docker-entrypoint.sh file and patch it
COPY --from=orig /docker-entrypoint.sh ./
COPY update-ca-certificates.patch /tmp/
RUN patch -p1 </tmp/update-ca-certificates.patch

# Get the custom_fields_controller.rb file and patch it
COPY --from=orig /usr/src/redmine/app/controllers/custom_fields_controller.rb\
 ./usr/src/redmine/app/controllers/
COPY public_custom_fields.patch /tmp/
RUN patch -p1 </tmp/public_custom_fields.patch

# Get git-remote plugin, tag 0.0.2 (newest release as of now)
RUN\
 git -C usr/src/redmine/plugins clone --quiet --branch 0.0.2\
  https://github.com/dergachev/redmine_git_remote

# Get scm_hookhelpers plugin, commit c913581 (newest release as of now)
RUN\
 git -C usr/src/redmine/plugins clone --quiet\
  https://github.com/lpirl/redmine_scm_hookhelpers &&\
 git -C usr/src/redmine/plugins/redmine_scm_hookhelpers\
  checkout c913581 --

# Remove the git repository from the plugins
RUN rm -rf usr/src/redmine/plugins/*/.git


FROM redmine
# This build stage is the final output image

COPY --from=build --chown=redmine:redmine /home/ /
