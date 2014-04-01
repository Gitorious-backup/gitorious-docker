# Gitorious Docker image

Gitorious [Docker](http://www.docker.io/) image includes the full set of
Gitorious applications and services and is the simplest way to get Gitorious
running on your own server.

NOTE: this is a fully working image but it needs a bit more testing/feedback to
be marked as "production ready".

## Basic concepts

Please read this chapter, which is about the basic concepts of this image (and
Docker in general) that you should first understand.

If you're in a hurry you can skip straight to **Starting/stopping the
container - The easy way**.

NOTE: it's assumed that you have correctly installed Docker on the machine that
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
use `-p 2222` as an option to `ssh` command when connecting to the host later).

### Data volume

Gitorious container keeps its state at `/var/lib/gitorious` (this is the
internal, container path) which is exposed as Docker's volume. It keeps
repository data, caches and config files in it. This allows for stopping and
starting new containers from the same image without losing all the data and
custom configuration. It will also ease the upgrade process in the future.

You want to map this volume to a directory on the host. We recommend to map to
the same directory name (`/var/lib/gitorious`):

    -v /var/lib/gitorious:/var/lib/gitorious

NOTE: It is highly recommended to do a frequent backup of this directory as it keeps
all the precious data (repositories and database files).

## Starting/stopping the container

To start Gitorious container run the following command, replacing port and
volume options with the ones that suit you best:

    sudo docker run ${PORT_OPTIONS} ${VOLUME_OPTIONS} gitorious/gitorious:latest

On the first run Docker will need to download Gitorious image from the public
Docker registry which will take a few minutes.

### The easy way: gitoriousctl

You can use the provided `gitoriousctl` script (you may need to clone this
repository first to get it) that makes starting, stopping and introspecting the
container easier.

Start the container with:

    ./gitoriousctl start

It runs the `docker run` command with the following options:

* `-p 7080:80 -p 7022:22 -p 9418:9418` for port forwarding,
* `-v /var/lib/gitorious:/var/lib/gitorious` for volume mapping.

Booting the application with all its components should not take longer than 60
seconds. You should then be able to access Gitorious at
[http://localhost:7080/](http://localhost:7080/).

Stop the container with:

    ./gitoriousctl stop

Check if the container is running:

    ./gitoriousctl status

If you know what your're doing and you want to inspect the running container
from the inside you can ssh into it with:

    ./gitoriousctl ssh

You can look at the `gitoriousctl` script to get familiar with managing the
container. Also feel free to adjust the values in it (ports, directory paths)
until you're happy with your setup.

Also, see [documentation of the docker run
command](http://docs.docker.io/en/latest/commandline/cli/#run) for additional
options you can use when starting the container.

## Configuration

The data volume mentioned in the previous paragraphs includes the `config`
directory that keeps several config files. If you've followed the above example
(and you haven't used a different volume mapping) you can find it mounted at
`/var/lib/gitorious/data/config` on the host system.

It contains the following files:

* `gitorious.yml` - main Gitorious configuration file,
* `database.yml` - database connection configuration,
* `smtp.yml` - SMTP server connection configuration,
* `authentication.yml` - authentication configuration.

You should edit `gitorious.yml` and set:

* `host`, `port` and `scheme` to match the ones your users will use when
  accessing Gitorious via the web browser. Host should be set to a proper FQDN
  and port should be set to the one you specified in the port mapping in the
  previous section,
* `ssh_daemon_port` to match the public ssh port that users will use for
  clone/pull/push over ssh protocol. This also should be set to the one you
  specified in the port mapping in the previous section.

Feel free to edit these files to suit your specific needs.

NOTE: if you used the example port mapping like shown in the previous section
(7080 for http, 7022 for ssh) the only thing you should set in `gitorious.yml`
is the `host` setting. If you're just playing with Gitorious you can even skip
this one as it only affects the generated URLs and defaults to localhost.

NOTE: when you make a change to any of the config files you have to restart the
container for changes to take effect.

### Note on a database

The image contains an internal MySQL instance that is used by default. It keeps
its data files at `/var/lib/gitorious/data/mysql` (and you should not touch
this directory). If you want to use your own MySQL instance then just edit
`database.yml` file and point it to your database.

### Note on email delivery

The image contains an internal Postfix instance that is used by default. It is
a basic Postfix installation that should work fine for testing, however you
should use your own SMTP server to ensure reliable email delivery. To point
Gitorious to your SMTP server edit `smtp.yml` file.

## Inspecting the running container

If you would like to inspect the running container you can access it via ssh as
a root user. There's no password set for root and the authentication is key
based. Put your public key in the `/var/lib/gitorious/config/authorized_keys`
file and log in using the mapped ssh port:

    cat ~/.ssh/id_rsa.pub | sudo tee /var/lib/gitorious/config/authorized_keys
    ssh root@localhost -p 7022

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
your system yet you can first run it in a [Vagrant](http://www.vagrantup.com/)
VM.

To do so make sure you have at least Vagrant 1.4 and VirtualBox 4.3, then run
the following commands:

    git clone https://git.gitorious.org/gitorious/gitorious-docker.git
    cd gitorious-docker
    vagrant up
    vagrant ssh
    cd /vagrant
    ./gitoriousctl start

Wait about 30-60 sec for all services to start up and then access Gitorious at
[http://localhost:7080/](http://localhost:7080/).

When running Gitorious container under Vagrant you can clone/pull/push from
either Vagrant's host system or Vagrant's guest VM. The example port
configuration (7080 for http, 7022 for ssh, 9418 for git) is also reflected in
Vagrant's port mapping which just maps the ports to the same numbers (see
Vagrantfile).

NOTE: when running the container in Vagrant, "host" term used in several places
in this documentation refers to Vagrant's guest (which is a host for the Docker
container at the same time).
