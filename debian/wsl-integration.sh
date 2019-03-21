#!/bin/bash

function integrate_with_wsl {

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
    PLAYBOOKS=${PLAYBOOKS_REPO}/debian-wsl

    # link bash configuration file and directory to live playbooks repo
    cp bashrc_d/.bashrc-wsl ${HOME}/.bashrc
    mkdir -p ${HOME}/.bashrc.d
    cp bashrc_d/customize_bash.sh ${HOME}/.bashrc.d
}

integrate_with_wsl