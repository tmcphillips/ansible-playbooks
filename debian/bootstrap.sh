#!/bin/bash

# Download and invoke this script in a new WSL Debian environment:
#
#   wget --no-check-certificate https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/vagrant-debian/bootstrap.sh -O bootstrap.sh
#   bash bootstrap.sh

function bootstrap_ansible_on_debian {

    # request user password for invoking commands using sudo
    read -s -p "SUDO password: " password

    # install git and OS-level dependencies of ansible
    echo $password | sudo -S apt update
    echo $password | sudo -S apt-get -y install git python-pip python-dev libffi-dev libssl-dev

    # install virtualenv in the site-wide Python 2 environment
    echo $password | sudo -S pip install virtualenv

    # create a temporary directory for remaining work
    BOOTSTRAP_TEMP_DIR=$(mktemp -d /tmp/bootstrap_ansible_XXXXXX)
    cd $BOOTSTRAP_TEMP_DIR

    # clone the ansible-playbooks repo into the temporary directory
    git clone https://github.com/tmcphillips/ansible-playbooks.git $PLAYBOOKS_REPO

    # install ansible in a new Python 2 virtual environment in the temporary directory
    virtualenv .venv-ansible-playbooks --system-site-packages
    source .venv-ansible-playbooks/bin/activate
    pip install ansible
}

bootstrap_ansible_on_debian