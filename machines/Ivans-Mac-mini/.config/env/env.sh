# Session environment for sh-family shells. Sourced by ~/.profile.
if [ -n "${__TOOLS_ENV_SOURCED-}" ]; then return; fi
export __TOOLS_ENV_SOURCED=1

export AUTOSSH_PORT="0"
export EDITOR="nvim"
export VISUAL="nvim"
export LESS="-R"
export FZF_CTRL_R_COMMAND=""
export FZF_DEFAULT_COMMAND="fd --type f --hidden --no-ignore --follow --exclude .git"
export GIT_CONFIG_NOSYSTEM="true"
export GNUPGHOME="$HOME/.gnupg"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
export OLLAMA_BASE_URL="http://192.168.50.6:11434/v1"
export _ZL_HYPHEN="1"

export GOPATH="/Volumes/Storage/Data/.go"
export HF_HOME="/Volumes/Storage/Data/.cache/huggingface"
export UV_PYTHON_INSTALL_DIR="/Volumes/Storage/Data/.local/share/uv/python"
export UV_TOOL_BIN_DIR="/Volumes/Storage/Data/.local/bin"
export UV_TOOL_DIR="/Volumes/Storage/Data/.local/share/uv/tools"

export PATH="/Volumes/Storage/Data/.go/bin${PATH:+:}$PATH"
for dir in /Volumes/Storage/Data/.npm/bin /Volumes/Storage/Data/.bun/bin /Volumes/Storage/Data/.local/bin; do
  if [ -d "$dir" ]; then
    export PATH="$PATH:$dir"
  fi
done
unset dir
