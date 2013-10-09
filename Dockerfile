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

RUN echo "root:docker" | chpasswd

ADD ./bin/gitorious /usr/bin/gitorious
RUN chmod a+x /usr/bin/gitorious

ADD ./config/database.yml /home/git/app/config/database.yml
ADD ./config/unicorn.rb /home/git/app/config/unicorn.rb
RUN chown -R git:git /home/git/app/config

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD ./config/nginx.conf /etc/nginx/sites-enabled/default

ADD ./config/supervisord.conf /etc/supervisord.conf

RUN mkdir -p /home/git/.ssh && touch /home/git/.ssh/authorized_keys
RUN chown -R git:git /home/git/.ssh
RUN chmod 0700 /home/git/.ssh && chmod 0600 /home/git/.ssh/authorized_keys

ADD ./gts.sh /home/git/gts.sh
ADD ./init.sh /home/git/init.sh
ADD ./start.sh /home/git/start.sh
ADD ./templates /home/git/templates

RUN su - git -c "ln -s /home/git/data/gitorious.yml /home/git/app/config && ln -s /home/git/data/mailer_config.rb /home/git/app/config/initializers/"

VOLUME ["/home/git/data"]
VOLUME ["/var/lib/mysql"]

EXPOSE 80
EXPOSE 22
EXPOSE 9418

ENTRYPOINT ["/home/git/gts.sh"]
CMD ["start"]
