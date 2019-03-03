#!/bin/bash

# Invoke this script in new WSL Debian environment:
# wget --no-check-certificate https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/wsl-debian/bootstrap.sh -q -O- | sudo bash

function bootstrap_ansible_in_wsl_debian {

    # install git and OS-level dependencies of ansible
    apt update; apt-get -y install git python-pip python-dev libffi-dev libssl-dev

    # install ansible in a Python virtual environment
    pip install virtualenv
    virtualenv ansible-venv --system-site-packages
    . ansible-venv/bin/activate
    pip install ansible

    # clone the ansible-playbooks repo
    git clone https://github.com/tmcphillips/ansible-playbooks.git
}

bootstrap_ansible_in_wsl_debian