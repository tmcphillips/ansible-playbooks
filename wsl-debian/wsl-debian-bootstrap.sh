#!/bin/bash
function bootstrap_ansible_in_wsl_debian {

    # install OS-level dependencies of ansible
    apt update
    apt-get -y install python-pip python-dev libffi-dev libssl-dev   

    # install ansible in a Python virtual environment
    pip install virtualenv
    virtualenv ansible-venv --system-site-packages
    . ansible-venv/bin/activate
    pip install ansible
    deactivate

    # clone the ansible-playbooks repo
    #git clone https://github.com/tmcphillips/ansible-playbooks.git
}

bootstrap_ansible_in_wsl_debian