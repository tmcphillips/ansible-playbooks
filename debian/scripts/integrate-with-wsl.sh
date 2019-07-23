#!/bin/bash

function integrate_with_wsl {

    # request user password for invoking commands using sudo
    read -s -p "SUDO password: " password

    # enable access to Unix permissions on files stored on mounted volumes
    if [ ! -f /etc/wsl.conf ] || [ $(diff etc/wsl.conf /etc/wsl.conf) ] ; then
        echo $password | sudo cp etc/wsl.conf /etc/wsl.conf
        printf "\n\n* Restart the LxxsManager service via Windows Task Manager to effect changes to /etc/wsl.conf *\n\n"
    fi

    # compute location of home directory of corresponding Windows account
    WINHOME=/mnt/c/Users/${USER}

    # share the .ssh directory with the one in the home directory of the corresponding Windows account
    if [ ! -L ${HOME}/.ssh ]; then
        ln -s ${WINHOME}/.ssh ${HOME}/.ssh
    fi

    # set correct permissions on Windows account .ssh directory and its contents
    chmod 700 ${WINHOME}/.ssh
    chmod 600 ${WINHOME}/.ssh/*

    # share the .aws directory with the one in the home directory of the corresponding Windows account
    if [ ! -L ${HOME}/.aws ]; then
        ln -s ${WINHOME}/.aws ${HOME}/.aws
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
    DEBIAN_PLAYBOOKS=${PLAYBOOKS_REPO}/debian

    # install ansible in a new Python 2 virtual environment within tjhe ansible-playbooks clone
    ANSIBLE_VENV_DIR=${PLAYBOOKS_REPO}/.venv-ansible-playbooks
    if [ ! -d "${ANSIBLE_VENV_DIR}" ]; then
        virtualenv ${ANSIBLE_VENV_DIR} --system-site-packages
        source ${ANSIBLE_VENV_DIR}/bin/activate
        pip install pyyaml ansible pywinrm
        deactivate
    fi

    # install custom .bashrc file and create .bashrc.d directory
    cp ${DEBIAN_PLAYBOOKS}/bashrc_d/wsl.bashrc ${HOME}/.bashrc
    BASHRC_D=${HOME}/.bashrc.d
    mkdir -p ${BASHRC_D}
    cp ${DEBIAN_PLAYBOOKS}/bashrc_d/customize_bash.sh ${BASHRC_D}
}

integrate_with_wsl
