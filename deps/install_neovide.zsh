#!/usr/bin/env zsh

export PATH=$HOME/.local/bin:$PATH

SCRIPT_ROOT=$(readlink -f `dirname $0`)
source $SCRIPT_ROOT/installer.zsh
NEOVIDE_BIN_URL=https://github.com/neovide/neovide/releases/latest/download/neovide.tar.gz
LOCAL_BIN_PATH=$HOME/.local/bin/
NEOVIDE_ICON_URL=https://raw.githubusercontent.com/neovide/neovide/main/assets/neovide-256x256.png
NEOVIDE_ICON_PATH=$HOME/.local/share/icons/custom/Neovide.png
NEOVIDE_DESKTOP_PATH=$HOME/.local/share/applications/Neovide.desktop

if [[ "$+commands[curl]" -eq "0" ]]
then
  echo "cURL is not installed. Installing cURL."
  install_package curl;
fi

if [[ "$+commands[neovide]" -eq "1" ]]
then
  echo "Neovide is already installed."
  return 0;
else
  curl -L $NEOVIDE_BIN_URL > $LOCAL_BIN_PATH/neovide.tar.gz
  cd $LOCAL_BIN_PATH
  tar xzf $LOCAL_BIN_PATH/neovide.tar.gz
fi

envsubst < $SCRIPT_ROOT/Neovide.desktop > $NEOVIDE_DESKTOP_PATH
curl -L $NEOVIDE_ICON_URL > $NEOVIDE_ICON_PATH

return 0;
