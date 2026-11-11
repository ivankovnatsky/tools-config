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

export GPG_TTY="$(tty)"

if [ -d "$HOME/bin" ]; then
  export PATH="$PATH:$HOME/bin"
fi
# Claude CLI lives in ~/.local/bin (hardcoded in binary)
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$PATH:$HOME/.local/bin"
fi
if [ -d /Applications/Obsidian.app/Contents/MacOS ]; then
  export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
fi
