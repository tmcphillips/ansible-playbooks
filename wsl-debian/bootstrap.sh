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

    # compute location of home directory of corresponding Windows account
    WINHOME=/mnt/c/Users/${USER}

    # share the .ssh directory with the one in the home directory of the corresponding Windows account
    if [ ! -L ${HOME}/.ssh ]; then
        ln -s ${WINHOME}/.ssh ${HOME}/.ssh
    fi

    # share the GitRepos directory with the one in the home directory of the corresponding Windows account
    GITREPOS=${WINHOME}/GitRepos
    if [ ! -L ${HOME}/GitRepos ]; then
        ln -s ${GITREPOS} ${HOME}/GitRepos
    fi

    # clone the ansible-playbooks repo if not already present
    PLAYBOOKS_REPO=${GITREPOS}/ansible-playbooks
    if [ ! -d "${GITREPOS}/ansible-playbooks" ]; then
        git clone git@github.com:tmcphillips/ansible-playbooks.git ${PLAYBOOKS_REPO}
    fi
    PLAYBOOKS=${PLAYBOOKS_REPO}/wsl-debian

    # link bash configuration file and directory to live playbooks repo
    rm -f ${HOME}/bashrc_d ; ln -s ${PLAYBOOKS}/bashrc_d    ${HOME}/bashrc_d
    rm -f ${HOME}/.bashrc  ; ln -s ${HOME}/bashrc_d/.bashrc ${HOME}/.bashrc
}

bootstrap_wsl_debian