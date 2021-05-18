#!/bin/bash

# This installation by default includes:
#   Python3 and Java
#
# To include NodeJS:
#   Uncomment `install_nodejs()` in MAIN

# Python3 & Java
install_default() {
  sudo apt install -y python3-pip
  pip3 install --user pynvim
  pip3 install --upgrade pynvim
  pip3 install flake8 autopep8 black isort
  sudo apt install -y default-jre default-jdk
}

# NodeJS
install_nodejs() {
  sudo apt install -y nodejs npm
  sudo npm install -g eslint
  sudo npm install -g prettier-standard standard
}

# Check for existing nvim config
if [ -d "$HOME/.config/nvim" ]; then
  echo "Installation will overwrite your current nvim configurations"
  read -p "Would you still like to continue? [Y/n] " RES
  case $RES in
    [Yy]) echo "Processing Installation";;
    *   ) echo "Installation Canceled"; exit;;
  esac
fi

TMP_DIR=$(mktemp -d $HOME/s20016-XXX)
CONFIG_DIR="$HOME/.config/nvim"
PLUGIN_DIR="$HOME/.local/share/nvim/site/autoload"

# Installing Neovim
if [ ! -d $CONFIG_DIR ]; then
  sudo apt update
  sudo apt install -y neovim
  mkdir -p $CONFIG_DIR
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  cd $TMP_DIR && git clone https://github.com/s20016/nvim.git
  # echo "call plug#begin(expand('~/.local/share/nvim/site/plugged'))" > $CONFIG_DIR/init.vim
  # echo "call plug#end()" >> $CONFIG_DIR/init.vim
  cp $TMP_DIR/nvim/conf/init.vim $CONFIG_DIR/.
  nvim +'PlugInstall --sync' +qa
  cp $TMP_DIR/nvim/conf/setting.vim $CONFIG_DIR/.
  cp $TMP_DIR/nvim/conf/mapping.vim $CONFIG_DIR/.
  cp $TMP_DIR/nvim/conf/plugins.vim $CONFIG_DIR/.
  mkdir $CONFIG_DIR/session
  nvim +'source $CONFIG_DIR/init.vim' +q
fi

# MAIN
install_default
# install_nodejs

nvim +'PlugInstall --sync' +qa
rm -rf $TMP_DIR
