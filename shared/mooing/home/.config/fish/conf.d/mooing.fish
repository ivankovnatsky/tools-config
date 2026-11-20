# Laptop-only fish setup; conf.d runs before config.fish.
status is-interactive; or exit

alias argocd 'argocd --grpc-web'
alias k kubectl
# pulumi comes from mise
alias p pulumi

if test -x /opt/homebrew/bin/mise
    /opt/homebrew/bin/mise activate fish | source
end

# Prefix for the kitty menu-bar title of this OS window; `wt` clears it.
function wt
    kitty @ set-user-vars "title_prefix=$argv"
end
