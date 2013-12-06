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
RUN     apt-get install -y -q supervisor
RUN     apt-get install -y -q openssh-server
RUN     apt-get install -y -q build-essential

## add some folders
RUN     mkdir -p /var/run/sshd
RUN     mkdir -p /var/log/supervisor

## set a password
RUN     echo "root:root" | chpasswd

## setup buildbot slave
RUN     pip install django-dotenv
RUN     pip install buildbot-slave
RUN     mkdir -p /data
ADD     ./slave  /data/slave
ADD     ./dotenv /data/slave/.env
RUN     buildslave upgrade-slave /data/slave

## ADD supervisord scripts
ADD     ./supervisord/ /etc/supervisor/conf.d/

#
#exposed ports & volumes
VOLUME  ["/data"]
EXPOSE  22

## RUN command
CMD     ["/usr/bin/supervisord", "-n"]
