FROM ubuntu:12.10
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update

RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

RUN cat /proc/mounts > /etc/mtab
RUN apt-get -y install mysql-server

ADD my.cnf /etc/mysql/my.cnf
ADD run /usr/local/bin/run

EXPOSE 3306
VOLUME ["/var/lib/mysql"]
VOLUME ["/var/log/mysql"]

CMD ["/usr/local/bin/run"]
