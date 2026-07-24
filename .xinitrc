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

[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

# Apply the autorandr profile matching the currently-connected monitors.
# Run before set-wallpaper/dwm so the wallpaper and bar come up at the
# correct resolution. On the desktop, fall back to the 'ultrawide' profile
# when nothing matches; on the laptop there is no desktop-only fallback to
# force, so just apply a matching profile if one exists (the internal panel
# is already lit by X at its preferred mode) and never fail the session.
if [[ "$(hostname)" == "kellen-laptop" ]]; then
  autorandr --change || true
else
  autorandr --change --default ultrawide || true
fi

# Wallpaper is chosen from the active autorandr profile (see ~/.local/bin/set-wallpaper).
set-wallpaper &

dwmblocks &
dunst &
pomo notify &

if [[ "$(hostname)" == "kellen-laptop" ]]; then
  setxkbmap -option ctrl:nocaps
  nm-applet --indicator &
  blueman-applet &
else
  arbtt-capture &
fi

exec dwm
