# Login shells get ~/.profile from ~/.zprofile, after /etc/zprofile's path_helper.
if [[ ! -o login && -f ~/.profile ]]; then
  . ~/.profile
fi
