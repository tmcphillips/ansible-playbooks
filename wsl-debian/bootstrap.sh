#!/bin/bash

# Download and invoke this script in a new WSL Debian environment:
#
#   wget --no-check-certificate https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/wsl-debian/bootstrap.sh -O bootstrap.sh
#   bash bootstrap.sh

function bootstrap_wsl_debian {

    # request user password for invoking commands using sudo
    read -s -p "Enter your WSL Debian account password for using sudo: " password

    # install git and OS-level dependencies of ansible
    echo $password | sudo -S apt update
    echo $password | sudo -S apt-get -y install git python-pip python-dev libffi-dev libssl-dev

    # install virtualenv in the site-wide Python 2 environment
    echo $password | sudo -S pip install virtualenv

    # install ansible in a new Python 2 virtual environment
    virtualenv .venv-ansible-playbooks --system-site-packages
    source .venv-ansible-playbooks/bin/activate
    pip install ansible

    # compute location home directory of corresponding Windows account
    WINHOME=/mnt/c/Users/${USER}

    # share the .ssh directory with the matching Windows account
    if [ ! -L .ssh ]; then
        ln -s ${WINHOME}/.ssh .ssh
    fi
    # clone the ansible-playbooks repo in the Windows user home directory tree if needed
    GITREPOS=${WINHOME}/GitRepos
    if [ ! -d "${GITREPOS}/ansible-playbooks" ]; then
        mkdir -p ${GITREPOS}
        git clone git@github.com:tmcphillips/ansible-playbooks.git ${GITREPOS}/ansible-playbooks
    fi
}

bootstrap_wsl_debian