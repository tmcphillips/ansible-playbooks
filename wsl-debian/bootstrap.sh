#!/bin/bash

# Invoke this script in new WSL Debian environment:
# wget --no-check-certificate https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/wsl-debian/bootstrap.sh -q -O- | bash

function bootstrap_ansible_in_wsl_debian {

    read -s -p "Enter your WSL Debian account password for using sudo: " password

     # install git and OS-level dependencies of ansible as root
    echo $password | sudo -S apt update
    echo $password | sudo -S apt-get -y install git python-pip python-dev libffi-dev libssl-dev

    # install ansible in a Python virtual environment
    pip install virtualenv
    virtualenv ansible-venv --system-site-packages
    . ansible-venv/bin/activate
    pip install ansible

    # clone the ansible-playbooks repo
    git clone https://github.com/tmcphillips/ansible-playbooks.git
}

bootstrap_ansible_in_wsl_debian