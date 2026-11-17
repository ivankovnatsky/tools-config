# Session environment for fish. Sourced by ~/.config/fish/config.fish.
set -q __TOOLS_ENV_SOURCED; and return
set -gx __TOOLS_ENV_SOURCED 1

set -gx AUTOSSH_PORT 0
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LESS -R
set -gx FZF_CTRL_R_COMMAND ''
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --no-ignore --follow --exclude .git'
set -gx GIT_CONFIG_NOSYSTEM true
set -gx GNUPGHOME $HOME/.gnupg
set -gx STARSHIP_CONFIG $HOME/.config/starship.toml
set -gx OLLAMA_BASE_URL 'http://${a3Ip}:11434/v1'
set -gx _ZL_HYPHEN 1

set -gx GOPATH ${home}/.go
set -gx TASKFORGE_VAULT "${home}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes"
set -gx UV_TOOL_BIN_DIR ${localBin}
set -gx UV_TOOL_DIR ${home}/.local/share/uv/tools

for dir in ${goBin} ${npmBin} ${home}/.bun/bin ${localBin}
    if test -d $dir
        set -gx PATH $PATH $dir
    end
end
