# ~/.bashrc
#
# If not running interactively, don't do anything
#environmental variables 

export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
set -o vi

#don't know 
[[ $- != *i* ]] && return

#aliases 
alias ls='ls --color=auto'
alias vi='vim'
alias asdf='cd ~/personal/projects'
alias convertor=~/scripts/convertor
alias grep='grep --color=auto'
alias dwminstall='make clean && make && make PREFIX=$HOME/.local/ install clean'
alias dwmuninstall='make PREFIX=$HOME/.local/ uninstall'
alias info='info --vi-keys'

PS1='[\u@\h \W]\$ '
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
#launch x session 
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi

# NVIDIA CUDA Toolkit 13.1
#export PATH=/usr/local/cuda-13.1/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-13.1/lib64:$LD_LIBRARY_PATH

alias devnagari=~/scripts/devanagari.sh

vimfzf() {
    local file=$(fzf)
    [ -n "$file" ] && vim "$file"
}
