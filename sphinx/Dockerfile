FROM gitorious/app
MAINTAINER Marcin Kulik

RUN apt-get -y install sphinxsearch

CMD ["bundle", "exec", "rake", "ts:start_in_foreground"]
USER git

# EXPOSE ??
