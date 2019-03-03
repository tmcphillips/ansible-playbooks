#!/bin/bash

# Invoke this script in new WSL Debian environment after manually installing curl:
#   sudo apt update; apt install -y curl
#   curl https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/wsl-debian/wsl-debian-bootstrap.sh | sudo bash

function bootstrap_ansible_in_wsl_debian {

    # install OS-level dependencies of ansible
    apt update; apt-get -y install python-pip python-dev libffi-dev libssl-dev   

    # install ansible in a Python virtual environment
    pip install virtualenv
    virtualenv ansible-venv --system-site-packages
    . ansible-venv/bin/activate
    pip install ansible

    # download the git installation playbook and run
    curl https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/wsl-debian/git.yml -o /tmp/git.yml
    ansible-playbook -K /tmp/git.yml

    # clone the ansible-playbooks repo
    git clone https://github.com/tmcphillips/ansible-playbooks.git
}

bootstrap_ansible_in_wsl_debian