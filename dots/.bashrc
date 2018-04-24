# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='$(
    [ $? -eq 0 ] && color=2 || color=1
    [ -z "${PWD##$HOME*}" ] && pwd="~${PWD#$HOME}" || pwd="$PWD"

    printf "\n"
    printf "\033[1;3%sm│\033[m %s%s\n" "$color" "$pwd" "$(git-status)"
    printf "\033[1;3%sm│\033[m " "$color"
)'

export FZF_DEFAULT_COMMAND='ag --depth 10 --hidden --ignore .git -f -g ""'

export FZF_DEFAULT_OPTS='--height 40%'

export PATH=$PATH:$HOME/bin

set -o vi

PLAN9=/home/natskyge/pkgsrc/plan9port export PLAN9
PATH=$PATH:$PLAN9/bin export PATH

alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

alias yt='youtube-viewer'
