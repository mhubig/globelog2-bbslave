import os
import dotenv

from os import environ as env
from twisted.application import service
from buildslave.bot import BuildSlave

dotenv.inject()

basedir = r'.'
rotateLength = 10000000
maxRotatedFiles = 10

# if this is a relocatable tac file, get the directory containing the TAC
if basedir == '.':
    import os.path
    basedir = os.path.abspath(os.path.dirname(__file__))

# note: this line is matched against to check that this is a buildslave
# directory; do not edit it.
application = service.Application('buildslave')

try:
  from twisted.python.logfile import LogFile
  from twisted.python.log import ILogObserver, FileLogObserver
  logfile = LogFile.fromFullPath(os.path.join(basedir, "twistd.log"),
                                 rotateLength=rotateLength,
                                 maxRotatedFiles=maxRotatedFiles)
  application.setComponent(ILogObserver, FileLogObserver(logfile).emit)
except ImportError:
  # probably not yet twisted 8.2.0 and beyond, can't set log yet
  pass

buildmaster_host = env('BUILDBOT_HOST', 'ci.imko.de')
buildmaster_port = env('BUILDBOT_PORT', 9989)
buildmaster_pwd  = env('BUILDBOT_PWD', 'geheim')

buildslave_name = 'ec2slave'
keepalive = 600
usepty = 0
umask = None
maxdelay = 300
allow_shutdown = None

s = BuildSlave(buildmaster_host, buildmaster_port, buildslave_name,
               buildmaster_pwd, basedir, keepalive, usepty, umask=umask,
               maxdelay=maxdelay, allow_shutdown=allow_shutdown)
s.setServiceParent(application)
