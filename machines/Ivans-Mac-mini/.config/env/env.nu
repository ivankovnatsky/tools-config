# Session environment for nushell. Sourced by config.nu.
load-env {
    AUTOSSH_PORT: "0"
    EDITOR: "nvim"
    VISUAL: "nvim"
    LESS: "-R"
    FZF_CTRL_R_COMMAND: ""
    FZF_DEFAULT_COMMAND: "fd --type f --hidden --no-ignore --follow --exclude .git"
    GIT_CONFIG_NOSYSTEM: "true"
    GNUPGHOME: ($env.HOME | path join ".gnupg")
    STARSHIP_CONFIG: ($env.HOME | path join ".config" "starship.toml")
    OLLAMA_BASE_URL: "http://192.168.50.6:11434/v1"
    _ZL_HYPHEN: "1"
    GOPATH: "/Volumes/Storage/Data/.go"
    HF_HOME: "/Volumes/Storage/Data/.cache/huggingface"
    UV_PYTHON_INSTALL_DIR: "/Volumes/Storage/Data/.local/share/uv/python"
    UV_TOOL_BIN_DIR: "/Volumes/Storage/Data/.local/bin"
    UV_TOOL_DIR: "/Volumes/Storage/Data/.local/share/uv/tools"
}

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend "/Volumes/Storage/Data/.go/bin"
    | append (
        ["/Volumes/Storage/Data/.npm/bin" "/Volumes/Storage/Data/.bun/bin" "/Volumes/Storage/Data/.local/bin"]
        | where {|dir| $dir | path exists }
    )
    | uniq
)
