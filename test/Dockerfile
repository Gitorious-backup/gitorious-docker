FROM gitorious/app
MAINTAINER Marcin Kulik

RUN su git -c "cd /srv/gitorious/app && \
               bundle install --without postgres" # to override "--without ... test ..."

CMD ["bundle", "exec", "rake"]
USER git
