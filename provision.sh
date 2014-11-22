#!/bin/bash

# Shell user settings.
USER_NAME=vagrant
USER_HOME=/home/$USER_NAME
DEFAULT_RUBY='2.1.5'

###############################################################################
# Functions
###############################################################################
# Most of the time we can get by with this DRY wrapper for sudo commands.
as_user() {
  echo "$USER_NAME:~$ > ${*}"
  su -l $USER_NAME -c "$*"
}

# Install the requested version of Ruby, with Bundler.
install_ruby() {
  as_user "rbenv install -s $1"
  as_user "RBENV_VERSION=$1 gem install bundler"
  as_user "rbenv rehash"
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
apt-get install -yfV         \
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
  python-software-properties \
  sqlite3                    \
  wget                       \
  zlib1g-dev                 \

# Install rbenv and ruby-build.
as_user "git clone https://github.com/sstephenson/rbenv.git $USER_HOME/.rbenv"
as_user "git clone https://github.com/sstephenson/ruby-build.git $USER_HOME/.rbenv/plugins/ruby-build"

# Setup bash to use rbenv for $USER_NAME.
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $USER_HOME/.bashrc
echo 'eval "$(rbenv init -)"'               >> $USER_HOME/.bashrc
echo 'cd /vagrant'                          >> $USER_HOME/.bashrc
echo 'gem: --no-document'                   >> $USER_HOME/.gemrc

# Install Ruby for $USER_NAME.
install_ruby $DEFAULT_RUBY
echo $DEFAULT_RUBY > $USER_HOME/.ruby-version

###############################################################################
# EDIT HERE!
# Install any Rubies (other than $DEFAULT_RUBY) required for individual apps.
###############################################################################
# e.g. `install_ruby 2.1.4`
