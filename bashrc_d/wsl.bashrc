
# set fundamental environment variables
export WINHOME=/mnt/c/Users/${USER}
export GITREPOS=${WINHOME}/OneDrive/GitRepos
export PLAYBOOKS=${GITREPOS}/ansible-playbooks

# ensure we start in WSL home directory
cd $HOME

# load configuration files in bashrc_d
for filename in ~/.bashrc.d/*.sh; do
    source $filename
done
