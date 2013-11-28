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
run     apt-get install -y -q build-essential

## setup buildbot slave
run     pip install buildbot-slave
run     mkdir -p /data/log
add     ./slave  /data/slave
add     ./_env   /data/slave/.env

## setup supervisor
add     ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
add     ./supervisor/conf.d/buildbot.conf /etc/supervisor/conf.d/buildbot.conf

## run command
volume ["/data"]
ENTRYPOINT ["/usr/bin/supervisord"]
