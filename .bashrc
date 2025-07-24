# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Set window title to "user@host: current-directory"

export OPENAI_API_KEY=$(cat $HOME/.keys/gpt)
export CARGO_HOME=/opt/cargo
export QUTE_CONFIG_DIR=$HOME/.config/qutebrowser
export PATH=$PATH:/home/kellen/.spicetify
export PROJECTDIR=$HOME/Projects
export FORESTDIR=$PROJECTDIR/forest
export DOTFILES=$PROJECTDIR/dotfiles

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s histappend
shopt -s checkwinsize # enables $COLUMNS and $ROWS
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob
shopt -s autocd
shopt -s cdspell dirspell

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# ------------------ set editor --------------------------------------
_have() { type "$1" &>/dev/null; }

set-editor() {
	export EDITOR="$1"
	export VISUAL="$1"
	export GH_EDITOR="$1"
	export GIT_EDITOR="$1"
	alias vi="\$EDITOR"
}
_have "vim" && set-editor vi
_have "nvim" && set-editor nvim

#----------------------- functions -----------------------------------
function ipyvim {
  # $1 session name
  # $2 virtualenv name (default to current virtualenv)
  if tmux has-session -t $1 2>/dev/null; then
    tmux attach -t $1
  else
    window_virtualenv=$2
    if [ "$2" = "" ]; then
      if [ "$VIRTUAL_ENV" != "" ]; then
        window_virtualenv="`basename \"$VIRTUAL_ENV\"`"
      fi
    fi
    tmux new-session -d -s $1
    tmux split-window -d -t $1 -h
    if [ "$window_virtualenv" != "" ]; then
      # virtualenv seems to not propagate properly...
      # inspiration: cenkalti https://github.com/Paczesiowa/virthualenv/issues/38
      virtualenv_instruction="workon $window_virtualenv"
      tmux send-keys -t $1 $virtualenv_instruction enter C-l
      tmux send-keys -t $1.right $virtualenv_instruction enter C-l
    fi
    tmux send-keys -t $1.right 'ipython' enter C-l
    tmux send-keys -t $1.left 'nvim' enter
    tmux resize-pane -t $1 -R 15
    tmux attach -t $1
  fi
}

ghu() {
  pullpush
  git submodule foreach --recursive pullpush
}

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

#----------------------- set status bar ----------------------------

PROMPT_LONG=20
PROMPT_MAX=95
PROMPT_AT=@

wd() {
	dir="${PWD##*/}"
	parent="${PWD%"/${dir}"}"
	parent="${parent##*/}"
	echo "$parent/$dir"
} && export wd

if _have starship; then
  function set_win_title(){
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
  }
  starship_precmd_user_func="set_win_title"

  eval "$(starship init bash)"
else
  __ps1() {
	  echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
	  local P='$' dir="${PWD##*/}" B countme short long double \
		  r='\[\e[31m\]' h='\[\e[36m\]' \
		  u='\[\e[33m\]' p='\[\e[34m\]' w='\[\e[35m\]' \
		  b='\[\e[36m\]' x='\[\e[0m\]' \
		  g='\[\e[90m\]' y='\[\e[32m\]'

	  [[ $EUID == 0 ]] && P='#' && u=$r && p=$u # root
	  [[ $PWD = / ]] && dir=/
	  [[ $PWD = "$HOME" ]] && dir='~'

	  B="$(git branch --show-current 2>/dev/null)"
	  [[ $dir = "$B" ]] && B=.
	  countme="$USER$PROMPT_AT$(hostname):$dir($B)\$ "

	  [[ $B == master || $B == main ]] && b="$r "
	  [[ -n "$B" ]] && B="$g($b$B$g)"
	  [[ -n "$VIRTUAL_ENV" ]] && venv="${g}($y $(basename "$VIRTUAL_ENV")${g})" || venv=""

	  short="$u\u$g$PROMPT_AT$h\h$g:$w$dir$B$venv$p$P$x "
	  long="${g}╔$u\u$g$PROMPT_AT$h\h$g:$w$dir$B$venv\n${g}╚$p$P$x "
	  double="${g}╔$u\u$g$PROMPT_AT$h\h$g:$w$dir\n${g}║$B$venv\n${g}╚$p$P$x "

	  if ((${#countme} > PROMPT_MAX)); then
		  PS1="$double"
	  elif ((${#countme} > PROMPT_LONG)); then
		  PS1="$long"
	  else
		  PS1="$short"
	  fi
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
  }
PROMPT_COMMAND="__ps1"
fi

if _have tmux; then
  if [[ -n "$TMUX" ]]; then
      tmux rename-window "$(wd)"
      if [[ -z "$VIMRUNTIME" ]]; then
	  echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
      fi
  fi

  nts() {
    tmux new-session -n $1 -s $1
  }

fi

# ---------------- fzf -------------------------------
if _have fzf; then

  export FZF_DEFAULT_OPTS='
      --height 40%
      --layout=reverse
      --border
      --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
      --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
      --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
      --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

  export FZF_DEFAULT_COMMAND="fdfind --type f --follow --hidden"

  vf() {
    local file
    file=$(fzf) || return  # if no file selected, return
    nvim "$file"
  }

  # Set up fzf key bindings and fuzzy completion
  eval "$(fzf --bash)"
fi

if _have direnv; then
  eval "$(direnv hook bash)"
fi

#----------------- node + rust slop ------------------
. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

