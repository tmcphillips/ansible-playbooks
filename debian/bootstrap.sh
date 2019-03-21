#!/bin/bash

# Download and invoke this script in a new Debian environment:
#
#   wget --no-check-certificate https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/debian/bootstrap.sh -O bootstrap.sh
#   bash bootstrap.sh

function bootstrap_ansible_on_debian {

    # request user password for invoking commands using sudo
    read -s -p "SUDO password: " password

    # install git and OS-level dependencies of ansible
    echo $password | sudo -S apt update
    echo $password | sudo -S apt-get -y install git python-pip python-dev libffi-dev libssl-dev

    # install virtualenv in the site-wide Python 2 environment
    echo $password | sudo -S pip install virtualenv

    # create a temporary directory tree for remaining work
    BOOTSTRAP_TEMP_DIR=$(mktemp -d /tmp/bootstrap_ansible_XXXXXX)

    # clone the ansible-playbooks repo
    ANSIBLE_PLAYBOOKS=${BOOTSTRAP_TEMP_DIR}/ansible-playbooks
    git clone https://github.com/tmcphillips/ansible-playbooks.git $ANSIBLE_PLAYBOOKS

    # install ansible in a new Python 2 virtual environment
    ANSIBLE_VENV=${BOOTSTRAP_TEMP_DIR}/ansible-venv
    virtualenv ${ANSIBLE_VENV} --system-site-packages
    source ${ANSIBLE_VENV}/bin/activate
    pip install ansible

    # enter playbbooks directory
    cd ${ANSIBLE_PLAYBOOKS}/debian
}

bootstrap_ansible_on_debian