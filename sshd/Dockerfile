FROM gitorious/app
MAINTAINER Marcin Kulik

RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

RUN apt-get -y install openssh-server 

RUN mkdir /var/run/sshd

# add empty authorized_keys file for git user
RUN mkdir -p /home/git/.ssh && touch /home/git/.ssh/authorized_keys && \
    chown -R git:git /home/git/.ssh && chmod 0700 /home/git/.ssh && \
    chmod 0600 /home/git/.ssh/authorized_keys

# ^^^ authorized_keys vs resque - needs sharing

# setup /usr/bin/gitorious so it executes bin/gitorious in the app dir
RUN ln -s /srv/gitorious/app/bin/gitorious /usr/bin/gitorious

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
