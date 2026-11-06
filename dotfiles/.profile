if [ -f ~/.config/env/env.sh ]; then
  . ~/.config/env/env.sh
fi

export HISTFILE="/dev/null"
export HISTFILESIZE="0"
export HISTSIZE="0"

if [[ -d /usr/local/bin ]]; then
  export PATH="/usr/local/bin:$PATH"
fi
if [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi
