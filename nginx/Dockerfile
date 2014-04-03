FROM gitorious/app
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y install nginx

ADD nginx.conf /etc/nginx/nginx.conf
ADD gitorious.conf.erb /etc/nginx/sites-available/default.erb
ADD gen-nginx-conf /usr/local/bin/gen-nginx-conf
ADD run /usr/local/bin/run

EXPOSE 80
VOLUME ["/var/log/nginx"]

CMD ["/usr/local/bin/run"]
