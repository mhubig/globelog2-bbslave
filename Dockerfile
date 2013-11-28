## metadata
from        ubuntu:12.04
maintainer  Markus Hubig <mhubig@imko.de>

## update & upgrade
run     echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list
run     apt-get -y update
run     apt-get -y upgrade

## install required software
run     apt-get install -y -q curl
run     apt-get install -y -q git
run     apt-get install -y -q wget
run     apt-get install -y -q gawk
run     apt-get install -y -q rsync
run     apt-get install -y -q unzip
run     apt-get install -y -q texinfo
run     apt-get install -y -q chrpath
run     apt-get install -y -q diffstat
run     apt-get install -y -q python-dev
run     apt-get install -y -q python-pip
run     apt-get install -y -q supervisor
run     apt-get install -y -q openssh-server
run     apt-get install -y -q build-essential

## setup buildbot slave
run     pip install django-dotenv
run     pip install buildbot-slave
run     mkdir -p /data
add     ./slave  /data/slave
add     ./dotenv /data/slave/.env

## add supervisord scripts
add     ./supervisord/ /etc/supervisor/conf.d/

## exposed ports & volumes
volume ["/data"]
expose 22

## run command
cmd ["/usr/bin/supervisord", "-n"]
