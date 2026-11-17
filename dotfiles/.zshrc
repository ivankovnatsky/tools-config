# ~/.profile exports history off for sh and bash; zsh keeps its own. Unexport
# so children don't inherit HISTFILE=~/.zsh_history next to HISTFILESIZE=0.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1024000
SAVEHIST=1024000
typeset +x HISTFILE HISTSIZE
setopt share_history extended_history hist_ignore_dups hist_expire_dups_first hist_ignore_space hist_fcntl_lock
setopt autocd extendedglob ignore_eof

autoload -U compinit && compinit
[ -f ~/.config/shell/aliases.sh ] && . ~/.config/shell/aliases.sh
mkcd() { mkdir -p "$1" && cd "$1"; }

b=/opt/homebrew
for p in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
  [ -f "$b/share/$p/$p.zsh" ] && . "$b/share/$p/$p.zsh"
done
[ -x "$b/bin/lua" ] && [ -f "$b/opt/z.lua/share/z.lua/z.lua" ] &&
  eval "$("$b/bin/lua" "$b/opt/z.lua/share/z.lua/z.lua" --init zsh)"
[ -x "$b/bin/fzf" ] && eval "$("$b/bin/fzf" --zsh)"
[ -x "$b/bin/atuin" ] && eval "$("$b/bin/atuin" init zsh --disable-up-arrow)"
[ -x "$b/bin/direnv" ] && eval "$("$b/bin/direnv" hook zsh)"
[ "$TERM" != dumb ] && [ -x "$b/bin/starship" ] && eval "$("$b/bin/starship" init zsh)"
unset b p

bindkey '^[l' down-case-word
bindkey '^[[Z' reverse-menu-complete
for m in main vicmd; do
  bindkey -M $m '^P' history-substring-search-up
  bindkey -M $m '^N' history-substring-search-down
done
bindkey -M vicmd k history-substring-search-up
bindkey -M vicmd j history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
unset m
