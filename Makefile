all: build

build:
	sudo docker build -t gitorious/gitorious .

push:
	sudo docker push gitorious/gitorious
