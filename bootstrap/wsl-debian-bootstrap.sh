#!/bin/bash
function setup_system_for_ansible {

    # install OS-level dependencies of ansible
    apt update
    apt-get -y install python-pip python-dev libffi-dev libssl-dev   

    # install ansible in a Python virtual environment
    pip install virtualenv
    virtualenv ansible-venv --system-site-packages
    . ansible-venv/bin/activate
    pip install ansible
    deactivate
}

setup_system_for_ansible