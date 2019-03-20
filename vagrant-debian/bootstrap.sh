#!/bin/bash

# Download and invoke this script in a new WSL Debian environment:
#
#   wget --no-check-certificate https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/vagrant-debian/bootstrap.sh -O bootstrap.sh
#   bash bootstrap.sh

function bootstrap_common_debian {

    # request user password for invoking commands using sudo
    read -s -p "SUDO password: " password

    # install git and OS-level dependencies of ansible
    echo $password | sudo -S apt update
    echo $password | sudo -S apt-get -y install git python-pip python-dev libffi-dev libssl-dev

    # install virtualenv in the site-wide Python 2 environment
    echo $password | sudo -S pip install virtualenv

    # install ansible in a new Python 2 virtual environment
    virtualenv .venv-ansible-playbooks --system-site-packages
    source .venv-ansible-playbooks/bin/activate
    pip install ansible
    deactivatef
}

function bootstrap_vagrant_debian {

    bootstrap_common_debian

    GITREPOS=${HOME}/GitRepos
    mkdir -p ${GITREPOS}
    PLAYBOOKS_REPO=${GITREPOS}/ansible-playbooks
    git clone https://github.com/tmcphillips/ansible-playbooks.git $PLAYBOOKS_REPO

    # link bash configuration file and directory to live playbooks repo
    rm -f ${HOME}/bashrc_d ; ln -s ${PLAYBOOKS}/bashrc_d    ${HOME}/bashrc_d
    rm -f ${HOME}/.bashrc  ; ln -s ${HOME}/bashrc_d/.bashrc ${HOME}/.bashrc
}

bootstrap_vagrant_debian