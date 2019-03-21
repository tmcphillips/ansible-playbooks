
# set fundamental environment variables
export WINHOME=/mnt/c/Users/${USER}
export GITREPOS=${WINHOME}/GitRepos
export PLAYBOOKS_REPO=${GITREPOS}/ansible-playbooks
export PLAYBOOKS=${PLAYBOOKS_REPO}/wsl-debian

# load configuration files in bashrc_d
for filename in .bashrc.d/*.sh; do
    source $filename
done
