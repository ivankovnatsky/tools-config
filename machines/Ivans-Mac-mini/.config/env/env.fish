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
set -gx OLLAMA_BASE_URL 'http://192.168.50.6:11434/v1'
set -gx _ZL_HYPHEN 1

set -gx GOPATH /Volumes/Storage/Data/.go
set -gx HF_HOME /Volumes/Storage/Data/.cache/huggingface
set -gx UV_PYTHON_INSTALL_DIR /Volumes/Storage/Data/.local/share/uv/python
set -gx UV_TOOL_BIN_DIR /Volumes/Storage/Data/.local/bin
set -gx UV_TOOL_DIR /Volumes/Storage/Data/.local/share/uv/tools

set -gx PATH /Volumes/Storage/Data/.go/bin $PATH
for dir in /Volumes/Storage/Data/.npm/bin /Volumes/Storage/Data/.bun/bin /Volumes/Storage/Data/.local/bin
    if test -d $dir
        set -gx PATH $PATH $dir
    end
end
