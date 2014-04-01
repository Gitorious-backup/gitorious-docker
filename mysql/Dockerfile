FROM ubuntu:12.10
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install mysql-server

# setup MySQL
RUN mysql_install_db
RUN mv /var/lib/mysql /var/lib/mysql-template
RUN ln -s /data/mysql /var/lib/mysql

ADD my.cnf /etc/mysql/my.cnf
