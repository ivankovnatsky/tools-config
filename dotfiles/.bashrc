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

b=/opt/homebrew
[ -x "$b/bin/lua" ] && [ -f "$b/opt/z.lua/share/z.lua/z.lua" ] &&
  eval "$("$b/bin/lua" "$b/opt/z.lua/share/z.lua/z.lua" --init bash)"
[ -x "$b/bin/fzf" ] && eval "$("$b/bin/fzf" --bash)"
if [ -x "$b/bin/atuin" ] && [ -f "$b/etc/profile.d/bash-preexec.sh" ]; then
  . "$b/etc/profile.d/bash-preexec.sh"
  eval "$("$b/bin/atuin" init bash --disable-up-arrow)"
fi
[ -x "$b/bin/direnv" ] && eval "$("$b/bin/direnv" hook bash)"
[ -x "$b/bin/mise" ] && eval "$("$b/bin/mise" activate bash)"
[ "$TERM" != dumb ] && [ -x "$b/bin/starship" ] && eval "$("$b/bin/starship" init bash)"
unset b
