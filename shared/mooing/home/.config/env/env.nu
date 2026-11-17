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
    OLLAMA_BASE_URL: "http://${a3Ip}:11434/v1"
    _ZL_HYPHEN: "1"
    GOPATH: "${home}/.go"
    TASKFORGE_VAULT: "${home}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes"
    UV_TOOL_BIN_DIR: "${localBin}"
    UV_TOOL_DIR: "${home}/.local/share/uv/tools"
    GPG_TTY: (do { ^tty } | complete | get stdout | str trim)
}

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend ["/opt/homebrew/bin"]
    | append (
        [
            "${goBin}"
            "${npmBin}"
            "${home}/.bun/bin"
            "${localBin}"
            ($env.HOME | path join "bin")
            "/Applications/Obsidian.app/Contents/MacOS"
        ]
        | where {|dir| $dir | path exists }
    )
    | uniq
)
