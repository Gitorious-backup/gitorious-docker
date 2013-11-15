VOLUME_OPTIONS=-v /var/lib/gitorious:/var/lib/gitorious
PORT_OPTIONS=-p 7080:80 -p 7022:22 -p 9418:9418

all: build

build:
	sudo docker build -t sickill/gitorious .

init: data-dir
	sudo docker run ${VOLUME_OPTIONS} sickill/gitorious:latest /srv/gitorious/docker/bin/seed

start: data-dir
	sudo docker run ${PORT_OPTIONS} ${VOLUME_OPTIONS} sickill/gitorious:latest

bash:
	sudo docker run ${VOLUME_OPTIONS} -t -i sickill/gitorious:latest /bin/bash

data-dir:
	sudo mkdir -p /var/lib/gitorious

clean:
	sudo rm -rf /var/lib/gitorious

push:
	sudo docker push sickill/gitorious
