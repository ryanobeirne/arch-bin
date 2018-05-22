[ $(echo $PATH | grep -o $HOME/bin) ] || export PATH=$PATH:$HOME/bin

# If not running interactively, don't do anything
#[[ $- != *i* ]] && return

sources=(
~/.aliases
~/.functions
/usr/share/bash-completion/bash_completion
/usr/share/git/git-prompt.sh
)
for s in "${sources[@]}"; do
	[ -r "$s" ] && . "$s"
done

_status () {
        s=$?
        [ $s == 0 ] || printf '%s' "[$s]"
}

export GIT_PS1_SHOWDIRTYSTATE=true
export PS1="\[\033[m\]\n\[\033[31m\]\$(_status)\[\033[01;32m\][\[\033[34m\]\u:\[\033[36m\]\w\[\033[32m\]]\[\033[00m\]\$(__git_ps1)\n\\$ "
export EDITOR=vim
export PAGER=vimpager

