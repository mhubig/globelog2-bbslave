#!/usr/bin/env python
# vi: set ft=python :

import os
from os import environ as env
from twisted.application import service
from buildslave.bot import BuildSlave

## bbmaster setting
BUILDBOT_ADDR = env.get('BUILDBOT_ADDR', False)
BUILDBOT_PORT = env.get('BUILDBOT_PORT', False)
BUILDBOT_PASS = env.get('BUILDBOT_PASS', False)

if False in (BUILDBOT_ADDR, BUILDBOT_PASS, BUILDBOT_PORT):
    sys.exit(1)

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
s = BuildSlave(BUILDBOT_ADDR, int(BUILDBOT_PORT), bbslave_name, BUILDBOT_PASS,
               bbslave_basedir, bbslave_keepalive, bbslave_usepty,
               umask=bbslave_umask, maxdelay=bbslave_maxdelay,
               allow_shutdown=bbslave_allow_shutdown)

## als add slave to application
s.setServiceParent(application)
