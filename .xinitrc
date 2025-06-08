export GOPATH=$HOME/.go

for dir in /opt/**/bin; do
  [ -d "$dir" ] && PATH="$dir:$PATH"
done

for dir in /opt/*/; do
  [ -d "$dir" ] && PATH="$dir:$PATH"
done

PATH="$PATH:$GOPATH/bin"
PATH="$PATH:/opt/bin"
PATH="$PATH:/usr/local/texlive/2025/bin/x86_64-linux"
PATH=$PATH:$HOME/.local/bin

export PATH

dwmblocks &
dunst &
feh --bg-scale $HOME/Pictures/nord-obito.jpg &
exec dwm
