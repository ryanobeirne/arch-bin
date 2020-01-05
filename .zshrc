[[ $- != *i* ]] && return

sources=(
	/etc/zsh/zshrc.sh
	/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
	~/.aliases
	~/.functions
	~/.LESS_TERMCAP
	~/.linuxterm
)
for s in "${sources[@]}"; do
  [ -r "$s" ] && . "$s"
done

export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTSIZE=20000
export EDITOR='vim'
export PAGER='less -iR'
export GOPATH=~/go
export LC_ALL=en_US.UTF-8
export HOSTALIASES=~/.config/hosts

mypaths=(~/bin ~/.cargo/bin /usr/lib/go/bin)
for p in "${mypaths[@]}"; do
	appendpath "$p"
done

# Load colors.
autoload -U colors
colors
# Allow for functions in the prompt.
setopt PROMPT_SUBST

__GIT_PROMPT() {
	which pretty-git-prompt &>/dev/null && pretty-git-prompt || printf '(git?)'
}

_ppid=$(ps --no-header -p $PPID -o comm)

__HOST_NAME() {
	[[ "$_ppid" == 'sshd' ]] && printf "$(hostname)│" || :
}

PROMPT='
%B┌[%(?.$fg[green].$fg[red])%?$reset_color%B]┤%K{8}%F{magenta} %n%f:%F{6}%~ %f%k│$(__HOST_NAME)%b $(__GIT_PROMPT)
%B└─▶ %#%b '

export SPROMPT="Come on, %B$fg[red]%R%b? How about %B$fg[green]%r%b? [%UY%ues|%UN%uo|%UA%ubort|%UE%udit]: "

# Key bindings
bindkey '[3~' delete-char
bindkey '' beginning-of-line
bindkey '[1~]' beginning-of-line
bindkey '' end-of-line
bindkey '[4~]' end-of-line
bindkey '' backward-kill-line
bindkey '' kill-buffer
bindkey '.' insert-last-word
bindkey '' undo
bindkey '  ' magic-space
bindkey '' vi-cmd-mode
bindkey '' history-incremental-search-backward
bindkey '' backward-kill-word
bindkey '' backward-delete-char

autoload -U compinit && compinit -i
zmodload -i zsh/complist
setopt correct autocd

# Blur terminal
if [[ "$_ppid" =~ '^yakuake|alacritty|urxvt|vim$' ]]; then
	for wid in $(xdotool search --pid $PPID); do
			xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid
	done
fi

ask_tmux() {
	printf 'Start tmux? [y/n]: '
	read -rsqk1 && exec tmux || clear
}

# Use tmux if terminal is alacritty, urxvt, vim. Ask if login shell.
case "$_ppid" in
	alacritty|urxvt|vim) 
		if tmux list-sessions &>/dev/null; then
			exec tmux a
		else
			exec tmux
		fi;;
	login) ask_tmux;;
esac
