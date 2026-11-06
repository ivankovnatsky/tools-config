# Plugins are cloned by tools gitRepos into ~/.local/share/fish-plugins.
for name in autopair bass colored-man-pages done fish-bd git-abbr forgit fzf-fish grc macos puffer
    if test $name = forgit
        if test -f /opt/homebrew/share/forgit/forgit.plugin.fish
            source /opt/homebrew/share/forgit/forgit.plugin.fish
        end
        continue
    end

    set -l plugin_dir ~/.local/share/fish-plugins/$name
    test -d $plugin_dir; or continue

    if test -d $plugin_dir/functions
        set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
    end

    if test -d $plugin_dir/completions
        set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
    end

    if test -d $plugin_dir/conf.d
        for f in $plugin_dir/conf.d/*.fish
            source $f
        end
    end

    if test -f $plugin_dir/key_bindings.fish
        source $plugin_dir/key_bindings.fish
    end

    if test -f $plugin_dir/init.fish
        source $plugin_dir/init.fish
    end
end
