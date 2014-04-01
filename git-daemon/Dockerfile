FROM ubuntu:12.10
MAINTAINER Marcin Kulik

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install git-daemon-sysvinit

CMD ["/usr/bin/git", "daemon", "--listen=0.0.0.0", "--export-all", "--base-path=/data/repositories", "--verbose", "--reuseaddr", "/data/repositories"]
USER daemon

EXPOSE 9418
