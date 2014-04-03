...

    # mysql
    docker run --name mysql-dev gitorious/mysql

    # redis
    docker run --rm --name redis gitorious/redis

    # memcache
    docker run --rm --name memcached gitorious/memcached

    # unicorn
    docker run --rm --name unicorn -v /tmp/gts/log/unicorn:/srv/gitorious/app/log -link mysql-dev:mysql -link redis:redis -link memcached:memcached gitorious/app bin/unicorn

    # nginx
    docker run --rm -p 1080:80 -v /tmp/gts/log/nginx:/var/log/nginx -link unicorn:unicorn gitorious/nginx
