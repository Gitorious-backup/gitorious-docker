#!/bin/bash

set -e

BASEDIR=/var/lib/gitorious
DATADIR=$BASEDIR/data
CONFIGDIR=$BASEDIR/config
DOCKERDIR=/srv/gitorious/docker
TEMPLATESDIR=$DOCKERDIR/templates

echo "~~ Initializing Gitorious..."

[[ -d $DATADIR/repositories ]] && echo "Error: initialization already done" && exit 1

export RAILS_ENV=production

echo "~~ Creating config and data directories..."
mkdir -p $CONFIGDIR
mkdir -p $DATADIR/repositories
mkdir -p $DATADIR/tarball-cache
mkdir -p $DATADIR/tarball-work
chown -R git:git $DATADIR

echo "~~ Copying default config files to $CONFIGDIR..."
cp $TEMPLATESDIR/gitorious.yml $CONFIGDIR
cp $TEMPLATESDIR/mailer.rb $CONFIGDIR

echo "~~ Creating mysql database..."
mysql_install_db >/dev/null
/usr/bin/mysqld_safe >/dev/null 2>&1 &
sleep 3
echo "create database gitorious; grant all privileges on gitorious.* to gitorious@localhost identified by 'yourpassword'" | mysql -u root

su git <<EOS
cd /home/git/app

echo "~~ Loading schema into the database..."
bin/rake db:schema:load >/dev/null 2>&1

# echo "~~ Creating Sphinx index..."
# bin/rake ts:index

# bin/create-user
EOS

echo "~~ Success. Gitorious initialized correctly."
