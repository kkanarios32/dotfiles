source $HOME/.profile
export GOPATH=$HOME/.go
export NODE_PATH="/home/kellen/.nvm/versions/node/v22.15.0/lib/node_modules"

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
arbtt-capture &
appschedule qutebrowser &

if [[ "$COMPUTER" == "laptop" ]]; then
  feh --bg-fill $HOME/Pictures/nord-obito.jpg
else 
  feh --bg-fill $HOME/Pictures/nord-gojo.png $HOME/Pictures/nord-zoro.png $HOME/Pictures/nord-ichigo.png &
fi

exec dwm
