FROM gitorious/app
MAINTAINER Marcin Kulik

WORKDIR /srv/gitorious/app

# bundle without ignoring "test" and "development" groups this time
RUN sudo -u git bundle install --without postgres

RUN apt-get -y install wget
RUN cd /tmp && wget -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 && \
    tar xf phantomjs-1.9.7-linux-x86_64.tar.bz2 && ln -s /tmp/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/bin/

CMD ["bin/rake"]
