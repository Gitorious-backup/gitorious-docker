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

RUN echo "root:docker" | chpasswd

RUN su git -c "git clone git://gitorious.org/gitorious/mainline.git /srv/gitorious/app; \
               cd /srv/gitorious/app; \
               git checkout babbc45; \
               git submodule update --recursive --init; \
               bundle install --deployment --without development test"

RUN apt-get -y install postfix

RUN echo "#!/bin/sh\n\nexec /srv/gitorious/app/bin/gitorious \"\$@\"" > /usr/bin/gitorious && chmod a+x /usr/bin/gitorious

RUN ln -s /srv/gitorious/docker/config/unicorn.rb /srv/gitorious/app/config/unicorn.rb; \
    ln -s /srv/gitorious/docker/config/memcache.yml /srv/gitorious/app/config/memcache.yml

RUN ln -s /var/lib/gitorious/config/database.yml /srv/gitorious/app/config/; \
    ln -s /var/lib/gitorious/config/gitorious.yml /srv/gitorious/app/config/; \
    ln -s /var/lib/gitorious/config/smtp.yml /srv/gitorious/app/config/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf; \
    ln -fs /srv/gitorious/docker/config/nginx.conf /etc/nginx/sites-enabled/default

RUN mysql_install_db
RUN mv /var/lib/mysql /var/lib/mysql-template
RUN ln -s /var/lib/gitorious/data/mysql /var/lib/mysql

RUN mkdir -p /home/git/.ssh && touch /home/git/.ssh/authorized_keys; \
    chown -R git:git /home/git/.ssh; \
    chmod 0700 /home/git/.ssh && chmod 0600 /home/git/.ssh/authorized_keys

ADD . /srv/gitorious/docker

RUN su git -c "cd /srv/gitorious/app && git fetch && git checkout b4c7677"

VOLUME ["/var/lib/gitorious"]

EXPOSE 80
EXPOSE 22
EXPOSE 9418

ENTRYPOINT ["/srv/gitorious/docker/bin/run"]
CMD ["supervisord", "-n", "-c", "/srv/gitorious/docker/config/supervisord.conf"]
