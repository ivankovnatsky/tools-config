if [ -f ~/.profile ]; then
  . ~/.profile
fi
[[ $- == *i* ]] || return
HISTCONTROL=ignoredups:ignorespace
set -o ignoreeof
[ -f ~/.config/shell/aliases.sh ] && . ~/.config/shell/aliases.sh

b=/opt/homebrew
[ -x "$b/bin/lua" ] && [ -f "$b/opt/z.lua/share/z.lua/z.lua" ] &&
  eval "$("$b/bin/lua" "$b/opt/z.lua/share/z.lua/z.lua" --init bash)"
[ -x "$b/bin/fzf" ] && eval "$("$b/bin/fzf" --bash)"
if [ -x "$b/bin/atuin" ] && [ -f "$b/etc/profile.d/bash-preexec.sh" ]; then
  . "$b/etc/profile.d/bash-preexec.sh"
  eval "$("$b/bin/atuin" init bash --disable-up-arrow)"
fi
[ -x "$b/bin/direnv" ] && eval "$("$b/bin/direnv" hook bash)"
[ "$TERM" != dumb ] && [ -x "$b/bin/starship" ] && eval "$("$b/bin/starship" init bash)"
unset b
