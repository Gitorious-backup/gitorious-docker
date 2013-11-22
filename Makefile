all: build

build:
	sudo docker build -t sickill/gitorious .

push:
	sudo docker push sickill/gitorious
