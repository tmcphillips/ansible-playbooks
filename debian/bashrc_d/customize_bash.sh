
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# enable color support of ls and also add handy aliases
#alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

function cd {
    cd_cmd="builtin cd $*"
    $cd_cmd
    print_dir_banner
}

# define xterm escape sequences
xterm_normal='\033[0m'
xterm_inverse='\033[7m'

# define an array of dashes to use for composing the banner
dashes="---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

function print_dir_banner {

    if [ -z "$COLUMNS" ]
    then
        cols=128
    else
        cols=COLUMNS
    fi

    pathlength=$((${#PWD}+4))
    leftdashcount=$((($cols-$pathlength)/2-1))
    rightdashcount=$cols-$pathlength-$leftdashcount

    if [ $leftdashcount -gt 0 ]
    then
        echo -ne "${xterm_normal}${dashes:0:$leftdashcount}${xterm_normal}"
        echo -ne "${xterm_inverse}  ${PWD}  ${xterm_normal}"
        echo -e "${xterm_normal}${dashes:0:$rightdashcount}${xterm_normal}"
    fi
}

# display current directory
print_dir_banner
