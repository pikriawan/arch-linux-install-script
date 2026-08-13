PROMPT='%F{blue}%1~%f %F{green}➜%f '

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt inc_append_history

autoload -U compinit && compinit

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char

alias ls='ls --color=auto'

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
