alias vpnc="/opt/cisco/secureclient/bin/vpn connect umvpn.umnet.umich.edu/umvpn-all-traffic-alt connect"
alias vpnd="/opt/cisco/secureclient/bin/vpn disconnect"
alias sshpc="sudo tailscale ssh kellen@kellen-pc"
alias ta="tmux attach"
alias schol="sr scholar"
alias sgh="sr github"

export CARGO_HOME=/opt/cargo
export QUTE_CONFIG_DIR=/home/kellen/.config/qutebrowser/

gpgconf --launch gpg-agent
export GPG_TTY=$(tty)

setopt histignorealldups sharehistory

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# CTRL-T
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable vi mode
bindkey -v

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# General binds
bindkey -s "^l" "clear\n"

alias glakes="ssh kellenkk@greatlakes.arc-ts.umich.edu"

glup(){
  scp -r "$1" kellenkk@greatlakes-xfer.arc-ts.umich.edu:"$2"
}
gldown(){
  scp -r kellenkk@greatlakes-xfer.arc-ts.umich.edu:"$1" "$2"
}

pcup(){
  scp -r "$1" kellen@kellen-pc.tail82ceca.ts.net:"$2"
}
pcdown(){
  scp -r kellen@kellen-pc.tail82ceca.ts.net:"$1" "$2"
}

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

export FZF_DEFAULT_COMMAND="fdfind --type f --follow --hidden --no-ignore-vcs"

# CTRL-R
export FZF_CTRL_R_OPTS='--sort --exact'

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}

zle -N fzf-history-widget-accept
bindkey '^R' fzf-history-widget-accept

# ALT-C
export FZF_ALT_C_OPTS=$FZF_DEFAULT_OPTS
export FZF_ALT_C_COMMAND="fdfind --type d --follow --hidden --no-ignore-vcs"
bindkey "ç" fzf-cd-widget

# VIM
fzf-vim() {
    FILE=$(fzf</dev/tty)
    [ -n "$FILE" ] && nvim "$FILE"
    zle reset-prompt
}

zle -N fzf-vim
bindkey '^F' fzf-vim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$PATH:/home/kellen/.spicetify
