# Gitorious in a Docker container

WARNING: this is proof of concept - not ready for production use!

## Building the image

NOTE: Skip this if you haven't modified the Dockerfile and you only want to run
a container from the already built image.

You can build the docker image for gitorious by running:

    make

This will tag the created image as "sickill/gitorious".

## Running the Gitorious container

NOTE: make sure you have docker installed (or jump to Vagrant section below).

### First run tasks

You need to initialize the container data directory first. Run:

    make init

It will create /var/lib/gitorious directory that will store Mysql data files,
git repositories, cached tarball and config files.

Now, edit /var/lib/gitorious/config/mailer.rb and set SMTP configurations
so Gitorious can deliver its emails.

### Starting the container

To start the container run:

    make start

Supervisor will start and monitor all the Gitorious processes as you will see
on the console.

You should now be able to access Gitorious at http://localhost:7080/

To stop the container just hit ctrl-c.

### Port mapping

Gitorious container exposes 3 ports: 22, 80 and 9418. By default, `make start`
task maps them to 7022, 7080 and 9418 accordingly.

If you're running a real server then you should change the mapping so the port
number on the host maps to the same port number in the container and adjust
gitorious.yml in /var/lib/gitorious/config/ dir.

NOTE: you need to prepend your ssh remote URL with `ssh://` as the displayed
URLs (with non-standard port) are wrong at the moment:

    git@localhost:7022/user/repo.git --> ssh://git@localhost:7022/user/repo.git

## Vagrant

To try it out in a VM you can use the example Vagrantfile:

    vagrant up
    vagrant ssh
    cd /vagrant
    make init
    # edit /var/lib/gitorious/config/mailer.rb
    make start

When running Gitorious container under Vagrant you can clone/pull/push from
either Vagrant's host system or the VM as the port forwarding just maps the
ports to the same numbers (see Vagrantfile).
