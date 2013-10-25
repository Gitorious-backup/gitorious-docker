FROM ubuntu:12.10

ENV RAILS_ENV production

RUN echo exit 101 > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN apt-get -y update

RUN apt-get -y install build-essential curl git redis-server \
               git-daemon-sysvinit nginx supervisor sphinxsearch \
               openssh-server mysql-client mysql-server libmysqlclient-dev \
               libpq-dev ruby ruby-dev rake libxml2-dev libxslt1-dev \
               libreadline6 libicu-dev memcached imagemagick

RUN mkdir /var/run/sshd

RUN gem install bundler --no-rdoc --no-ri

RUN adduser git

RUN mkdir -p /srv/gitorious && chown git:git /srv/gitorious

RUN su git -c "git clone git://gitorious.org/gitorious/mainline.git /srv/gitorious/app; \
               cd /srv/gitorious/app; \
               git checkout 7e21ba5; \
               git submodule update --recursive --init; \
               bundle install --deployment --without development test"

RUN echo "root:docker" | chpasswd

ADD . /srv/gitorious/docker

RUN ln -s /srv/gitorious/docker/bin/gitorious /usr/bin/gitorious

RUN ln -s /srv/gitorious/docker/config/database.yml /srv/gitorious/app/config/database.yml; \
    ln -s /srv/gitorious/docker/config/unicorn.rb /srv/gitorious/app/config/unicorn.rb; \
    ln -s /srv/gitorious/docker/config/memcache.yml /srv/gitorious/app/config/memcache.yml

RUN ln -s /var/lib/gitorious/config/gitorious.yml /srv/gitorious/app/config/; \
    ln -s /var/lib/gitorious/config/mailer.rb /srv/gitorious/app/config/initializers/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf; \
    ln -fs /srv/gitorious/docker/config/nginx.conf /etc/nginx/sites-enabled/default

RUN rm -rf /var/lib/mysql && ln -s /var/lib/gitorious/data/mysql /var/lib/mysql

RUN mkdir -p /home/git/.ssh && touch /home/git/.ssh/authorized_keys; \
    chown -R git:git /home/git/.ssh; \
    chmod 0700 /home/git/.ssh && chmod 0600 /home/git/.ssh/authorized_keys

VOLUME ["/var/lib/gitorious"]

EXPOSE 80
EXPOSE 22
EXPOSE 9418

ENTRYPOINT ["/srv/gitorious/docker/bin/gts"]
CMD ["start"]
