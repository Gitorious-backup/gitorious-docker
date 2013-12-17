# Gitorious Docker image

NOTE: this is a fully working image but it needs a bit more testing to be
production ready.

Gitorious Docker image includes the full set of Gitorious applications and
services and is the simplest way to get Gitorious running on your own server.

## Basic concepts

Please read this chapter about the basic concepts of this image (and Docker in
general).

NOTE: it assumed that you have correctly installed Docker on the machine that
is meant to host Gitorious. See [the official Docker installation
instructions](http://www.docker.io/gettingstarted/#h_installation).

### Ports

The container exposes 3 ports: http port, git protocol port and ssh port.
Docker allows you to map the internal port numbers to host port numbers via
`-p` option of the `run` command.

To map all 3 ports to the same port numbers on the host use the following
options:

    -p 80:80 -p 22:22 -p 9418:9418

NOTE: Container runs its own sshd instance. Mapping container's ssh port to
host's port 22 requires you to first free this port on the host. You can change
the port number of ssh daemon that runs on the host to for example 2222 (and
use `-p 2222` as an option to ssh command when connecting to the host later).

### Data volume

Gitorious container keeps its state at _/var/lib/gitorious_ (this is the
internal, container path) which is exposed as Docker's volume. It keeps
repository data, caches and config files in it. This allows for stopping and
starting new containers from the same image without losing all the data and
custom configuration. It will also ease the upgrade process in the future.

You want to map this volume to a directory on the host. We recommend to map to
the same directory name (_/var/lib/gitorious_):

    -v /var/lib/gitorious:/var/lib/gitorious

## Starting the container

To start Gitorious container run the following command, replacing port and
volume options with the ones that suit you best:

    sudo docker run ${PORT_OPTIONS} ${VOLUME_OPTIONS} gitorious/gitorious:latest

On the first run Docker will need to download Gitorious image from the public
Docker registry.

You can use the provided `start` script that makes it easier by defaulting to:

* `-p 7080:80 -p 7022:22 -p 9418:9418` for port forwarding,
* `-v /var/lib/gitorious:/var/lib/gitorious` for volume mapping.

Look at this script to get familiar with starting the container. Also feel
free to adjust the values in it until you're happy with your setup.

Booting the application with all its components should not take longer than 30
seconds. You should then be able to access Gitorious at
[http://localhost:7080/](http://localhost:7080/).

To stop the container just hit ctrl-c.

## Configuration

The data volume mentioned in the previous paragraphs includes the _config_
directory that keeps several config files. If you've followed the above example
(and you haven't used a different volume mapping) you can find it mounted at
_/var/lib/gitorious/data/config_ on the host system.

It contains the following files:

* gitorious.yml - main Gitorious configuration file,
* database.yml - database connection configuration,
* smtp.yml - SMTP server connection configuration.

Feel free to edit these files to suit your specific needs.

### Note on a database

The image contains an internal MySQL instance that is used by default. It keeps
its data files at _/var/lib/gitorious/data/mysql_ (and you should not touch
this directory). If you want to use your own MySQL instance then just edit
_database.yml_ file and point it to your database.

### Note on email delivery

The image contains an internal Postfix instance that is used by default. It is
a basic Postfix installation that should work fine for testing, however you
should use your own SMTP server to ensure reliable email delivery. To point
Gitorious to your SMTP server edit _smtp.yml_ file.

## Building the image

If you want to customize the image beyond what's possible via configuration
files you can build your own Gitorious image.

First, edit Dockerfile and/or other files from this repository. Then build a
new image by running:

    sudo docker build -t gitorious/gitorious .

There's a Makefile that simplifies the above to:

    make

## Trying Gitorious Docker image in Vagrant

If you just want to check out Gitorious and you don't want to install Docker on
your system yet you can first run it in a Vagrant VM.

To do so run the following commands:

    git clone https://git.gitorious.org/gitorious/gitorious-docker.git
    cd gitorious-docker
    vagrant up
    vagrant ssh
    cd /vagrant
    ./start

When running Gitorious container under Vagrant you can clone/pull/push from
either Vagrant's host system or the guest VM as the Vagrant port forwarding
just maps the ports to the same numbers (see Vagrantfile).

NOTE: when running the container in Vagrant "host" term used in several places
in this documentation refers to Vagrant's guest (which is a host for the Docker
container at the same time).
