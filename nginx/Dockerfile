FROM gitorious/app
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install nginx

ADD nginx.conf /etc/nginx/nginx.conf
ADD gitorious.conf /etc/nginx/sites-enabled/default

RUN su git -c "cd /srv/gitorious/app && \
               git submodule update --recursive --init && \
               bundle exec rake assets:precompile"

VOLUME ["/var/log/nginx"]

CMD ["/usr/sbin/nginx"]

EXPOSE 80
