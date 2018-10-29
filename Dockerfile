FROM redmine AS orig
# This build stage is just a source for an unpatched file


FROM alpine AS build
# This build stage actually prepares all files

# Install git tool and configure it
# Run `docker build --no-cache .` to update dependencies
RUN\
 apk add --no-cache git &&\
 git config --global advice.detachedHead false

# Set up work directory
WORKDIR /home
RUN mkdir plugins

# Get the config.ru file and patch it
COPY --from=orig /usr/src/redmine/config.ru ./
COPY relative_url_root.patch /tmp/
RUN patch -p1 </tmp/relative_url_root.patch

# Get git-remote plugin, tag 0.0.2 (newest release as of now)
RUN\
 git -C plugins clone --quiet --branch 0.0.2\
  https://github.com/dergachev/redmine_git_remote

# Remove the git repository from the plugins
RUN rm -rf plugins/*/.git


FROM redmine
# This build stage is the final output image

COPY --from=build --chown=redmine:redmine /home/ /usr/src/redmine/
