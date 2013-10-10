FROM ubuntu:12.10
# ENV RAILS_ENV production < enable this and remove RAILS_ENV from all other places

RUN echo exit 101 > /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

RUN apt-get -y update

RUN apt-get -y install build-essential curl git
RUN apt-get -y install redis-server git-daemon-sysvinit nginx supervisor sphinxsearch openssh-server
RUN apt-get -y install mysql-client mysql-server libmysqlclient-dev libpq-dev
RUN apt-get -y install ruby ruby-dev rake
RUN apt-get -y install libxml2-dev libxslt1-dev libreadline6 libicu-dev

RUN mkdir /var/run/sshd

RUN gem install bundler --no-rdoc --no-ri

RUN adduser git

RUN su git -c "git clone git://gitorious.org/gitorious/mainline.git /home/git/app"
RUN su git -c "cd /home/git/app && git checkout next && git submodule update --recursive --init"

RUN su git -c "cd /home/git/app && bundle install --deployment --without development test"

RUN apt-get install -y memcached

RUN echo "root:docker" | chpasswd

ADD . /srv/gitorious/docker

RUN ln -s /srv/gitorious/docker/bin/gitorious /usr/bin/gitorious

RUN ln -s /srv/gitorious/docker/config/database.yml /home/git/app/config/database.yml; \
    ln -s /srv/gitorious/docker/config/unicorn.rb /home/git/app/config/unicorn.rb; \
    ln -s /srv/gitorious/docker/config/memcache.yml /home/git/app/config/memcache.yml

RUN ln -s /var/lib/gitorious/config/gitorious.yml /home/git/app/config/; \
    ln -s /var/lib/gitorious/config/mailer.rb /home/git/app/config/initializers/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf; \
    ln -fs /srv/gitorious/docker/config/nginx.conf /etc/nginx/sites-enabled/default

RUN mkdir -p /home/git/.ssh && touch /home/git/.ssh/authorized_keys; \
    chown -R git:git /home/git/.ssh; \
    chmod 0700 /home/git/.ssh && chmod 0600 /home/git/.ssh/authorized_keys

VOLUME ["/var/lib/gitorious"]
VOLUME ["/var/lib/mysql"]

EXPOSE 80
EXPOSE 22
EXPOSE 9418

ENTRYPOINT ["/srv/gitorious/docker/gts.sh"]
CMD ["start"]
