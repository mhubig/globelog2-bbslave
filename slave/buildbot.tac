#!/usr/bin/env python
# vi: set ft=python :

import os
import dotenv

from twisted.application import service
from buildslave.bot import BuildSlave

## load the dotenv file
dotenv.read_dotenv()

## bbslave settings
bbslave_basedir = os.path.abspath(os.path.dirname(__file__))
bbslave_logdir = os.path.join(bbslave_basedir, 'twistd.log')
bbslave_rotate_length = 10000000
bbslave_max_rotated_files = 10
bbslave_name = 'ec2slave'
bbslave_keepalive = 600
bbslave_usepty = 0
bbslave_umask = None
bbslave_maxdelay = 300
bbslave_allow_shutdown = None

## bbmaster settings
bbmaster_host = os.environ.get('BUILDBOT_ADDR', 'ci.imko.de')
bbmaster_port = int(os.environ.get('BUILDBOT_PORT', '9989'))
bbmaster_pass = os.environ.get('BUILDBOT_PASS', 'geheim')

## create the application
application = service.Application('buildslave')

## add logging
try:
    from twisted.python.logfile import LogFile
    from twisted.python.log import ILogObserver, FileLogObserver
    logfile = LogFile.fromFullPath(bbslave_logdir,
                                   rotateLength=bbslave_rotate_length,
                                   maxRotatedFiles=bbslave_max_rotated_files)
    application.setComponent(ILogObserver, FileLogObserver(logfile).emit)
except ImportError:
    pass

## create the slave
s = BuildSlave(bbmaster_host, bbmaster_port, bbslave_name, bbmaster_pass,
               bbslave_basedir, bbslave_keepalive, bbslave_usepty,
               umask=bbslave_umask, maxdelay=bbslave_maxdelay,
               allow_shutdown=bbslave_allow_shutdown)

## als add slave to application
s.setServiceParent(application)
