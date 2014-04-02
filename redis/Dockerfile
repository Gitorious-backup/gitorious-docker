FROM ubuntu:12.10
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install redis-server

ADD redis.conf /etc/redis/redis.conf
ADD run /usr/local/bin/run

EXPOSE 6379
VOLUME ["/var/lib/redis"]
VOLUME ["/var/log/redis"]

CMD ["/usr/local/bin/run"]
