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
	if [ $s == 0 ]; then
		 printf '%s' "$s"
	 else
		 printf '\e[31m%s' "$s"
	fi
}

export GIT_PS1_SHOWDIRTYSTATE=true
export PS1="\[\e[0m\]
\[\e[1;32m\]┌[\$(_status)\e[1;32m]\[\e[32m\]┤\[\e[40;35m\] \u\e[37m@\e[32m\h\e[37m:\[\e[36m\]\w \[\e[0;1;32m\]│\[\e[m\]\[\e[37m\]\$(__git_ps1)\[\e[m\]
\[\e[1;32m\]└─▶\[\e[0m\] \\$ "
export EDITOR='vim -p'
export PAGER='less -iR'
