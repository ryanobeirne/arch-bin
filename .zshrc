sources=(
  /etc/zsh/zshrc.sh
	/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ~/.aliases
  ~/.functions
)
for s in "${sources[@]}"; do
  [ -r "$s" ] && . "$s"
done

export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTSIZE=20000
export EDITOR='vim -p'
export PAGER=vimpager
export GIT_PAGER='less -IR'

export LC_ALL=en_US.UTF-8
# Load colors.
autoload -U colors
colors
# Allow for functions in the prompt.
setopt PROMPT_SUBST
RPROMPT='$(~/repos/pretty-git-prompt/target/debug/pretty-git-prompt)'

PROMPT='
%B┌[%(?.$fg[green].$fg[red])%?$reset_color%B]┤%K{8}%F{magenta} %n%f:%F{6}%~ %f%k│%b
%B└─▶ %#%b '

export SPROMPT="Come on, %B$fg[red]%R%b? How about %B$fg[green]%r%b? [%UY%ues|%UN%uo|%UA%ubort|%UE%udit]: "

# Key bindings
bindkey '[3~' delete-char
bindkey '' beginning-of-line
bindkey '' end-of-line
bindkey '' backward-kill-line
#bindkey '' forward-kill-line
bindkey '.' insert-last-word
bindkey 'u' undo
bindkey ' ' magic-space

autoload -U compinit && compinit -i
zmodload -i zsh/complist
setopt correct
