## metadata
FROM        ubuntu:12.04
MAINTAINER  Markus Hubig <mhubig@imko.de>

## update & upgrade
RUN     echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list
RUN     apt-get -y update
RUN     apt-get -y upgrade

## install required software
RUN     apt-get install -y -q curl
RUN     apt-get install -y -q git
RUN     apt-get install -y -q wget
RUN     apt-get install -y -q gawk
RUN     apt-get install -y -q rsync
RUN     apt-get install -y -q unzip
RUN     apt-get install -y -q texinfo
RUN     apt-get install -y -q chrpath
RUN     apt-get install -y -q diffstat
RUN     apt-get install -y -q python-dev
RUN     apt-get install -y -q python-pip
RUN     apt-get install -y -q openssh-server
RUN     apt-get install -y -q build-essential

## add some folders
RUN     mkdir -p /var/run/sshd

## set a password
RUN     echo "root:root" | chpasswd

## setup buildbot slave
RUN     pip install buildbot-slave
RUN     pip install fabric
RUN     mkdir -p /data
ADD     ./slave /data/slave
ADD     ./fabfile.py /data

## expose ssh port
EXPOSE  22

## set the workdir
WORKDIR /data

## RUN command
CMD     ["/usr/local/bin/fab", "run"]
