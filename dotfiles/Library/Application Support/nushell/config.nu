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
# mise's init is a module, so it must be `use`d; its export-env pins PATH, so
# 0- sorts it before autoload files that prepend to PATH (carapace).
if ("/opt/homebrew/bin/mise" | path exists) {
  let mise_module = ($nu.cache-dir | path join "mise.nu")
  mkdir $nu.cache-dir
  ^/opt/homebrew/bin/mise activate nu | save -f $mise_module
  $"use ($mise_module | to nuon)\n" | save -f ($autoload_dir | path join "0-mise.nu")
} else {
  rm -f ($autoload_dir | path join "0-mise.nu")
}

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
