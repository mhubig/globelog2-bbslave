from fabric.api import local

def update_slave():
    local('buildslave upgrade-slave slave')

def start_buildbot():
    local('buildslave start --nodaemon slave')

def run():
    update_slave()
    start_buildbot()
