set -q __fish_tools_config_sourced; and exit
set -g __fish_tools_config_sourced 1

if test -f ~/.config/env/env.fish
    source ~/.config/env/env.fish
end

# /etc/paths.d appends Homebrew after /usr/bin; brew tools must win.
fish_add_path --global --move --prepend /opt/homebrew/bin

set -U fish_term24bit 1

if test -x /opt/homebrew/bin/lua; and test -f /opt/homebrew/opt/z.lua/share/z.lua/z.lua
    /opt/homebrew/bin/lua /opt/homebrew/opt/z.lua/share/z.lua/z.lua --init fish | source
end

status is-interactive; or exit

alias agy 'agy --dangerously-skip-permissions'
alias c claude
alias codex 'codex --sandbox danger-full-access'
alias erd 'erd --color auto --human -L 1 --layout inverted --icons --long --hidden'
alias g git
alias less 'less -RS'
alias mkdir 'mkdir -p'
alias stc 'stc -homedir ~/Library/Application\ Support/Syncthing'
alias syncthing 'syncthing serve --no-browser'
alias zb 'z -b'
alias zf 'z -I'
alias zh 'z -I -t .'
alias zi 'z -i'
alias zz 'z -c'

if test -f /opt/homebrew/opt/fzf/shell/key-bindings.fish
    source /opt/homebrew/opt/fzf/shell/key-bindings.fish
end
if test -f /opt/homebrew/opt/fzf/shell/completion.fish
    source /opt/homebrew/opt/fzf/shell/completion.fish
end

set -gx GPG_TTY (tty)

set fish_greeting

# Set the variable instead of calling fish_vi_key_bindings so autopair's
# --on-variable handler fires. https://github.com/jorgebucaran/autopair.fish/issues/16
set -g fish_key_bindings fish_vi_key_bindings

bind -M insert \ca beginning-of-line
bind -M insert \ce end-of-line
bind \ca beginning-of-line
bind \ce end-of-line

# Require typing 'exit' instead of Ctrl+D
bind --preset -e \cd
bind \cd true

if test -d $HOME/bin
    set -gx PATH $PATH $HOME/bin
end

# Claude CLI lives in ~/.local/bin (hardcoded in binary)
if test -d $HOME/.local/bin
    set -gx PATH $PATH $HOME/.local/bin
end

if test -d /Applications/Obsidian.app/Contents/MacOS
    set -gx PATH $PATH /Applications/Obsidian.app/Contents/MacOS
end

# FIXME: drop once https://github.com/fish-shell/fish-shell/pull/10133 ships
complete -f -c git -n '__fish_git_using_command branch' -l contains -d 'List branches that contain the specified commit' -xa '(__fish_git_commits)'
complete -f -c git -n '__fish_git_using_command branch' -l no-contains -d 'List branches that don\'t contain the specified commit' -xa '(__fish_git_commits)'

# https://github.com/remigourdon/dotfiles/commit/733971c51c7dd1050b786c0fdc7ce04bd2661197
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

set -gx FORGIT_LOG_FORMAT "%C(auto)%h %s %C(brightblack)%cr%Creset"
# forgit hardcodes --height=80%, leaving 20% blank below the preview
set -gx FORGIT_FZF_DEFAULT_OPTS "--height=100%"
set -gx FORGIT_LOG_FZF_OPTS "--preview-window=bottom:90%"
set -gx FORGIT_DIFF_FZF_OPTS "--preview-window=bottom:90%"
set -gx FORGIT_SHOW_FZF_OPTS "--preview-window=bottom:90%"
set -gx FORGIT_BLAME_FZF_OPTS "--preview-window=bottom:90%"
set -gx FORGIT_REFLOG_FZF_OPTS "--preview-window=bottom:90%"

# Only offer forgit subcommands until one is entered
complete -c git-forgit -n __fish_is_first_arg -a "add attributes blame branch_delete checkout_branch checkout_commit checkout_file checkout_tag cherry_pick cherry_pick_from_branch clean diff fixup squash reword ignore log reflog rebase reset_head revert_commit show stash_show stash_push"
complete -c git-forgit -n __fish_is_first_arg -f

if test "$TERM" != dumb; and test -x /opt/homebrew/bin/starship
    /opt/homebrew/bin/starship init fish | source
end

if test -x /opt/homebrew/bin/carapace
    /opt/homebrew/bin/carapace _carapace fish | source
end

if test -x /opt/homebrew/bin/atuin
    /opt/homebrew/bin/atuin init fish --disable-up-arrow | source
end

if test -x /opt/homebrew/bin/direnv; and not functions -q __direnv_export_eval
    /opt/homebrew/bin/direnv hook fish | source
end
