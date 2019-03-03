#!/bin/bash

# Download and invoke this script in a new WSL Debian environment:
#
#   wget --no-check-certificate https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/wsl-debian/bootstrap.sh -O bootstrap.sh
#   bash bootstrap.sh

function bootstrap_ansible_in_wsl_debian {

    # request user password for invoking commands using sudo
    read -s -p "Enter your WSL Debian account password for using sudo: " password

    # install git and OS-level dependencies of ansible
    echo $password | sudo -S apt update
    echo $password | sudo -S apt-get -y install git python-pip python-dev libffi-dev libssl-dev

    # install virtualenv in the site-wide Python 2 environment
    echo $password | sudo -S pip install virtualenv

    # clone the ansible-playbooks repo
    git clone https://github.com/tmcphillips/ansible-playbooks.git

    # install ansible in a new Python 2 virtual environment inside the local ansible-playbooks clone
    virtualenv ansible-playbooks/.ansible-venv --system-site-packages
    source ansible-playbooks/.ansible-venv/bin/activate
    pip install ansible
}

bootstrap_ansible_in_wsl_debian