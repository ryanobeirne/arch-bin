sources=(
  /etc/zshrc
  /etc/zprofile
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/local/opt/zsh-git-prompt/zshrc.sh
  ~/.aliases
  ~/.functions
  ~/.amazon_keys
)
for s in "${sources[@]}"; do
  [ -r "$s" ] && . "$s"
done

export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTSIZE=20000
export EDITOR=vim
export PAGER=vimpager
export GIT_PAGER='less -IR'

allpaths=($(cat /etc/{paths,paths.d/*}))
PATH+=$(
  for i in "${allpaths[@]}"; do
    [[ -d "$i" && ! $(echo "$PATH" | tr ':' '\n' |  grep "^$i\$") ]] && echo "$i"
  done | tr '\n' ':' | sed 's/:$//'
)
fpath+=(/usr/local/share/zsh-completions)
fpath=($(printf '%s\n' ${fpath[@]} | sort | uniq))

# PROMPT='
# %B┌[%F{yellow}%?%f]┤%K{0}%F{magenta}%n%f:%F{6}%~%f%k│%b $(git_super_status)
# %B└─▶ %#%b '
PROMPT='
%B┌[%(?.$fg[green].$fg[red])%?$reset_color%B]┤%K{8}%F{magenta} %n%f:%F{6}%~ %f%k│%b $(git_super_status)
%B└─▶ %#%b '
export SPROMPT="Come on, %B$fg[red]%R%b? How about %B$fg[green]%r%b? [%UY%ues|%UN%uo|%UA%ubort|%UE%udit]: "

# Key bindings
bindkey '[3~' delete-char
bindkey '[H' beginning-of-line
bindkey '[F' end-of-line
bindkey ''   backward-kill-line
bindkey ' ' magic-space

autoload -U compinit && compinit -i
zmodload -i zsh/complist
setopt correct
