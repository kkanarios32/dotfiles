alias vpnc="/opt/cisco/secureclient/bin/vpn connect umvpn.umnet.umich.edu/umvpn-all-traffic-alt"
alias vpnd="/opt/cisco/secureclient/bin/vpn disconnect"
alias sshpc="sudo tailscale ssh kellen@kellen-pc"
alias ta="tmux attach"
alias ttf="tt -n 30"
alias as="arbtt-stats"
alias ash="arbtt-stats  --filter='\$sampleage<=1:00'"
alias ast="arbtt-stats  --filter='\$date>='`date +"%Y-%m-%d"`"
alias asw="arbtt-stats --filter='\$date>='`date -d '7 days ago' +\"%Y-%m-%d\"` --for-each=day"
alias ?="gpt"
alias ??='sr google -browser=w3m'
alias glakes="ssh kellenkk@greatlakes.arc-ts.umich.edu"
alias gitl="git log -n 5 --graph --decorate --oneline"
alias udots='stow -d "$DOTFILES" -t "$HOME" -v . --ignore="\.env|\.venv/*|\.local/opt/*|install" --adopt'
alias dots='cd $DOTFILES'
alias cdf='cd $FORESTDIR'
alias scripts='cd $DOTFILES/.local/bin'
alias today="gcalcli agenda '$(date +%Y-%m-%d)' '$(date -d tomorrow +%Y-%m-%d)' --military --nodeclined"
alias wn='watch -n 1 nvidia-smi'
alias wnm='nvidia-smi --query-gpu=timestamp,utilization.memory,memory.used --format=csv -l 1'


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='dunstify --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
