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

PROMPT='
%B┌[%(?.$fg[green].$fg[red])%?$reset_color%B]┤%K{8}%F{magenta} %n%f:%F{6}%~ %f%k│%b $(pretty-git-prompt)
%B└─▶ %#%b '

export SPROMPT="Come on, %B$fg[red]%R%b? How about %B$fg[green]%r%b? [%UY%ues|%UN%uo|%UA%ubort|%UE%udit]: "

# Key bindings
bindkey '[3~' delete-char
bindkey '' beginning-of-line
bindkey '[1~]' beginning-of-line
bindkey '' end-of-line
bindkey '[4~]' end-of-line
bindkey '' backward-kill-line
bindkey '' kill-line
bindkey '' backward-word
bindkey '' forward-word
bindkey '.' insert-last-word
bindkey 'u' undo
bindkey '  ' magic-space
bindkey ''	vi-cmd-mode
bindkey '' history-incremental-search-backward
bindkey '' backward-kill-word
bindkey '' backward-delete-char

autoload -U compinit && compinit -i
zmodload -i zsh/complist
setopt correct

# Blur terminal
_ppid=$(ps --no-header -p $PPID -o comm)
if [[ "$_ppid" =~ '^yakuake|alacritty|urxvt|vim$' ]]; then
	for wid in $(xdotool search --pid $PPID); do
			xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid
	done
fi

# Use tmux if terminal is alacritty or urxvt
[[ "$_ppid" =~ '^alacritty|urxvt|vim$' ]] && exec tmux || :
