# Login bash reads only this, not ~/.profile.
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
