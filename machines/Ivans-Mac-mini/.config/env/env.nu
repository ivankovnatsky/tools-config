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
    GOPATH: "${externalStoragePath}/.go"
    HF_HOME: "${externalStoragePath}/.cache/huggingface"
    UV_PYTHON_INSTALL_DIR: "${externalStoragePath}/.local/share/uv/python"
    UV_TOOL_BIN_DIR: "${externalStoragePath}/.local/bin"
    UV_TOOL_DIR: "${externalStoragePath}/.local/share/uv/tools"
    UV_CACHE_DIR: "${externalStoragePath}/.cache/uv"
    UV_PYTHON_PREFERENCE: "only-managed"
    GPG_TTY: (do { ^tty } | complete | get stdout | str trim)
}

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend ["/opt/homebrew/bin" "${externalStoragePath}/.go/bin"]
    | append (
        [
            "${externalStoragePath}/.npm/bin"
            "${externalStoragePath}/.bun/bin"
            "${externalStoragePath}/.local/bin"
            ($env.HOME | path join "bin")
            ($env.HOME | path join ".local" "bin")
            "/Applications/Obsidian.app/Contents/MacOS"
        ]
        | where {|dir| $dir | path exists }
    )
    | uniq
)
