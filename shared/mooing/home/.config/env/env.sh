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
export OLLAMA_BASE_URL="http://${a3Ip}:11434/v1"
export _ZL_HYPHEN="1"

export GOPATH="${home}/.go"
export TASKFORGE_VAULT="${home}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes"
export UV_TOOL_BIN_DIR="${localBin}"
export UV_TOOL_DIR="${home}/.local/share/uv/tools"

for dir in ${goBin} ${npmBin} ${home}/.bun/bin ${localBin}; do
  if [ -d "$dir" ]; then
    export PATH="$PATH:$dir"
  fi
done
unset dir
