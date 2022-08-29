#!/bin/bash

# Shell user settings.
USER_NAME=vagrant
USER_HOME=/home/$USER_NAME
DEFAULT_RUBY='3.1.2'

###############################################################################
# Functions
###############################################################################
# Most of the time we can get by with this DRY wrapper for sudo commands.
as_user() {
  echo "$USER_NAME:~$ > ${*}"
  su -l $USER_NAME -c "$*"
}

###############################################################################
# Base System
###############################################################################
apt-get -y update
apt-get -yfV dist-upgrade

###############################################################################
# rbenv & ruby-build, and Rubies
# From https://github.com/sstephenson/rbenv
# and https://github.com/sstephenson/ruby-build
###############################################################################

# Install dependencies.
sudo apt-get install -yfV         \
  build-essential            \
  curl                       \
  git-core                   \
  libcurl4-openssl-dev       \
  libreadline-dev            \
  libsqlite3-dev             \
  libssl-dev                 \
  libxml2-dev                \
  libxslt1-dev               \
  libyaml-dev                \
  software-properties-common \
  sqlite3                    \
  zlib1g-dev                 \
  autoconf                   \
  bison                      \
  libreadline6-dev           \
  libncurses5-dev            \
  libffi-dev                 \
  libgdbm6                   \
  libgdbm-dev                \
  libdb-dev                  \
  uuid-dev

# Install rbenv and ruby-build.
as_user "git clone https://github.com/sstephenson/rbenv.git $USER_HOME/.rbenv"
as_user "git clone https://github.com/sstephenson/ruby-build.git $USER_HOME/.rbenv/plugins/ruby-build"

# Setup bash to use rbenv for $USER_NAME.
truncate -s 0 $USER_HOME/.bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $USER_HOME/.bashrc
echo 'eval "$(rbenv init -)"'               >> $USER_HOME/.bashrc
echo 'cd /vagrant'                          >> $USER_HOME/.bashrc

echo 'gem: --no-document' > $USER_HOME/.gemrc

# Install the requested version of Ruby, with Bundler.
as_user "rbenv install -s $DEFAULT_RUBY"
as_user "rbenv global $DEFAULT_RUBY"
as_user "RBENV_VERSION=$DEFAULT_RUBY gem install bundler"
as_user "cd /vagrant && bundle"
