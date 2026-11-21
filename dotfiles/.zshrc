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
[ -f ~/.config/shell/mooing.sh ] && . ~/.config/shell/mooing.sh
mkcd() { mkdir -p "$1" && cd "$1"; }

has() { command -v "$1" >/dev/null; }
for p in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
  for f in /opt/homebrew/share/$p/$p.zsh /usr/share/zsh/plugins/$p/$p.zsh; do
    [ -f "$f" ] && { . "$f"; break; }
  done
done
if has lua; then
  for f in /opt/homebrew/opt/z.lua/share/z.lua/z.lua /usr/share/z.lua/z.lua; do
    [ -f "$f" ] && { eval "$(lua "$f" --init zsh)"; break; }
  done
fi
has fzf && eval "$(fzf --zsh)"
has atuin && eval "$(atuin init zsh --disable-up-arrow)"
has direnv && eval "$(direnv hook zsh)"
has carapace && source <(carapace _carapace zsh)
has mise && eval "$(mise activate zsh)"
[ "$TERM" != dumb ] && has starship && eval "$(starship init zsh)"
unset -f has
unset p f

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
