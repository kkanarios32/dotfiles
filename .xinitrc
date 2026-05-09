#!/usr/bin/bash

export DISPLAY=:0
export GOPATH=$HOME/.go
export NODE_PATH="/home/kellen/.nvm/versions/node/v22.15.0/lib/node_modules"
export PROJECTDIR=$HOME/Projects
export FORESTDIR=$PROJECTDIR/forest
export DOTFILES=$PROJECTDIR/dotfiles

PATH="$(find -L /opt -type d -name bin 2>/dev/null | paste -sd: -):$PATH"
PATH="$(find -L /opt -mindepth 1 -maxdepth 1 -type d | paste -sd: -):$PATH"

PATH="$PATH:$GOPATH/bin"
PATH="$PATH:/usr/local/texlive/2025/bin/x86_64-linux"
export PATH="$(find -L $HOME/.local/bin/ -type d -print | paste -sd: -):$PATH"

export PATH

dwmblocks &
dunst &
pomo notify &

if [[ "$(hostname)" == "kellen-laptop" ]]; then
  feh --bg-fill $HOME/Pictures/nord-gojo.png
  setxkbmap -option ctrl:nocaps
  nm-applet --indicator &
  blueman-applet &
else
  arbtt-capture &
  feh --bg-fill $HOME/Pictures/nord-gojo.png $HOME/Pictures/nord-zoro.png $HOME/Pictures/nord-ichigo.png &
fi

exec dwm
