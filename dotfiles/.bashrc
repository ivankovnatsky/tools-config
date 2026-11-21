if [ -f ~/.profile ]; then
  . ~/.profile
fi
[[ $- == *i* ]] || return
# bash-preexec (atuin) reads `history 1`, so in-memory history must be on;
# HISTFILE=/dev/null from .profile keeps it off disk.
export -n HISTSIZE
HISTSIZE=1000
HISTCONTROL=ignoredups:ignorespace
set -o ignoreeof
[ -f ~/.config/shell/aliases.sh ] && . ~/.config/shell/aliases.sh
[ -f ~/.config/shell/mooing.sh ] && . ~/.config/shell/mooing.sh

has() { command -v "$1" >/dev/null; }
if has lua; then
  for f in /opt/homebrew/opt/z.lua/share/z.lua/z.lua /usr/share/z.lua/z.lua; do
    [ -f "$f" ] && { eval "$(lua "$f" --init bash)"; break; }
  done
fi
has fzf && eval "$(fzf --bash)"
if has atuin; then
  for f in /opt/homebrew/etc/profile.d/bash-preexec.sh /usr/share/bash-preexec/bash-preexec.sh; do
    [ -f "$f" ] && { . "$f"; eval "$(atuin init bash --disable-up-arrow)"; break; }
  done
fi
has direnv && eval "$(direnv hook bash)"
has carapace && source <(carapace _carapace bash)
has mise && eval "$(mise activate bash)"
[ "$TERM" != dumb ] && has starship && eval "$(starship init bash)"
unset -f has
unset f
