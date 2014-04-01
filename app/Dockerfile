FROM ubuntu:12.10
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update

ENV RAILS_ENV production

# disable startup of services during image creation
RUN echo exit 101 > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

# install required packages
RUN apt-get -y install build-essential curl git mysql-client \
               libmysqlclient-dev ruby ruby-dev rake libxml2-dev libxslt1-dev \
               libreadline6 libicu-dev imagemagick

# install bundler
RUN gem install bundler --no-rdoc --no-ri

# create dir for the app and docker's files
RUN mkdir -p /srv/gitorious && chown git:git /srv/gitorious

# checkout and build the app in /srv/gitorious/app
RUN su git -c "git clone git://gitorious.org/gitorious/mainline.git /srv/gitorious/app && \
               cd /srv/gitorious/app && \
               git checkout v3.0.1 && \
               bundle install --deployment --without development test postgres"

# symlink internal config files
RUN ln -s /srv/gitorious/docker/config/unicorn.rb /srv/gitorious/app/config/; \
    ln -s /srv/gitorious/docker/config/memcache.yml /srv/gitorious/app/config/; \
    ln -s /srv/gitorious/docker/config/gitorious.overrides.yml /srv/gitorious/app/config/

# symlink external (exposed) config files
RUN ln -s /var/lib/gitorious/config/database.yml /srv/gitorious/app/config/; \
    ln -s /var/lib/gitorious/config/gitorious.yml /srv/gitorious/app/config/; \
    ln -s /var/lib/gitorious/config/smtp.yml /srv/gitorious/app/config/; \
    ln -s /var/lib/gitorious/config/authentication.yml /srv/gitorious/app/config/

# expose log files
RUN rm -rf /srv/gitorious/app/log && ln -s /var/lib/gitorious/data/logs /srv/gitorious/app/log

# copy all files from gitorious-docker repo to the image
ADD . /srv/gitorious/docker

# expose directory with data and config files to the host
VOLUME ["/var/lib/gitorious"]
