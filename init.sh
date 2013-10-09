#!/bin/bash

set -e

echo "~~ Initializing Gitorious..."

[[ -d /home/git/data/repositories ]] && echo "Error: initialization already done" && exit 1

export RAILS_ENV=production

echo "~~ Creating data directories..."
mkdir -p /home/git/data/repositories /home/git/data/tarball-cache /home/git/data/tarball-work
chown -R git:git /home/git/data

echo "~~ Copying default config files to data dir..."
cp /home/git/templates/gitorious.yml /home/git/data/
cp /home/git/templates/mailer_config.rb /home/git/data/

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
