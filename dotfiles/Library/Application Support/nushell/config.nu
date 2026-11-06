const env_file = ("~/.config/env/env.nu" | path expand)
const env_source = if ($env_file | path exists) { $env_file } else { null }
source $env_source

def --env yy [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXX")
  ^yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}

# Init scripts are regenerated each start; vendor autoload files run after config.nu.
let autoload_dir = ($nu.data-dir | path join "vendor" "autoload")
mkdir $autoload_dir
if ("/opt/homebrew/bin/starship" | path exists) {
  ^/opt/homebrew/bin/starship init nu | save -f ($autoload_dir | path join "starship.nu")
} else {
  rm -f ($autoload_dir | path join "starship.nu")
}
if ("/opt/homebrew/bin/carapace" | path exists) {
  ^/opt/homebrew/bin/carapace _carapace nushell | save -f ($autoload_dir | path join "carapace.nu")
} else {
  rm -f ($autoload_dir | path join "carapace.nu")
}
if ("/opt/homebrew/bin/atuin" | path exists) {
  ^/opt/homebrew/bin/atuin init nu --disable-up-arrow | save -f ($autoload_dir | path join "atuin.nu")
} else {
  rm -f ($autoload_dir | path join "atuin.nu")
}

const fzf_bindings = "/opt/homebrew/opt/fzf/shell/key-bindings.nu"
const fzf_bindings_source = if ($fzf_bindings | path exists) { $fzf_bindings } else { null }
source $fzf_bindings_source
const fzf_completion = "/opt/homebrew/opt/fzf/shell/completion.nu"
const fzf_completion_source = if ($fzf_completion | path exists) { $fzf_completion } else { null }
source $fzf_completion_source

$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt?
    | default []
    | append {||
        if not ("/opt/homebrew/bin/direnv" | path exists) { return }
        let direnv = (
            ^/opt/homebrew/bin/direnv export json
            | from json --strict
            | default {}
        )

        for key in ($direnv | columns) {
            if ($direnv | get $key) == null {
                hide-env --ignore-errors $key
            }
        }

        $direnv
        | items {|key, value|
            let value = do (
                {
                  "PATH": {
                    from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
                    to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
                  }
                }
                | merge ($env.ENV_CONVERSIONS? | default {})
                | get ([[value, optional, insensitive]; [$key, true, true] [from_string, true, false]] | into cell-path)
                | if ($in | is-empty) { {|x| $x} } else { $in }
            ) $value
            return [ $key $value ]
        }
        | where {|pair| $pair.1 != null }
        | into record
        | load-env
    }
)
