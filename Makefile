VOLUME_OPTIONS=-v `pwd`/data:/home/git/data -v `pwd`/mysql:/var/lib/mysql
PORT_OPTIONS=-p 7080:80 -p 7022:22 -p 9418:9418

all: build

build:
	sudo docker build -t sickill/gitorious .

init: clean data-dirs
	sudo docker run ${VOLUME_OPTIONS} sickill/gitorious:latest init

start:
	sudo docker run ${PORT_OPTIONS} ${VOLUME_OPTIONS} sickill/gitorious:latest

bash:
	sudo docker run ${VOLUME_OPTIONS} -t -i sickill/gitorious:latest /bin/bash

data-dirs:
	mkdir -p data mysql

clean:
	sudo rm -rf data mysql
