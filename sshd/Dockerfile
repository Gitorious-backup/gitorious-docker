FROM gitorious/app
MAINTAINER Marcin Kulik

RUN apt-get -y install openssh-server 

# enable ssh root access via keys stored in host's config/authorized_keys
# RUN mkdir /root/.ssh && ln -s /var/lib/gitorious/config/authorized_keys /root/.ssh/authorized_keys

RUN mkdir /var/run/sshd

# add empty authorized_keys file for git user
RUN mkdir -p /home/git/.ssh && touch /home/git/.ssh/authorized_keys; \
	chown -R git:git /home/git/.ssh; \
	chmod 0700 /home/git/.ssh && chmod 0600 /home/git/.ssh/authorized_keys

# ^^^ authorized_keys vs resque - needs sharing

# setup /usr/bin/gitorious so it executes bin/gitorious in the app dir
RUN echo "#!/bin/sh\n\nexec /srv/gitorious/app/bin/gitorious \"\$@\"" > /usr/bin/gitorious && chmod a+x /usr/bin/gitorious

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
