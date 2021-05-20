#!/bin/bash

# This installation by default includes:
#   Python3 and Java
#
# To include NodeJS: Uncomment Ln: 15-17

# Python3, Java, NodeJS
install_default() {
  sudo apt install -y python3-pip
  pip3 install --user pynvim
  pip3 install --upgrade pynvim
  pip3 install flake8 autopep8 black isort
  sudo apt install -y default-jre default-jdk
  # sudo apt install -y nodejs npm
  # sudo npm install -g eslint
  # sudo npm install -g prettier-standard standard
}

TMP_DIR=$(mktemp -d $HOME/s20016-XXX)
BACKUP_DIR="$HOME/ORIGINAL_CONF"
CONFIG_DIR="$HOME/.config/nvim"
SESSIO_DIR="$HOME/.config/nvim/session"
ALPLUG_DIR="$HOME/.local/share/nvim/site/plugged"

# Change tab color in lightline-gruvbox
gruvbox_tab() {
	sed -i '146s/4/0/g; 153s/mono0/green/g; 153s/5/0/g' \
		$ALPLUG_DIR/lightline-gruvbox.vim/plugin/lightline-gruvbox.vim
	}

# Save backup if $CONFIG_DIR exist
if [ -d $CONFIG_DIR ]; then
  echo "Installation will overwrite your current nvim configurations"
  read -p "Would you still like to continue? [Y/n] " RES
  case $RES in
    [Yy])
      echo "Processing Installation";
      mkdir $BACKUP_DIR;
      mv $CONFIG_DIR $BACKUP_DIR;
			rm -rf $ALPLUG_DIR/
      if [ ! -d $CONFIG_DIR ]; then
        echo "Backup Saved To $BACKUP_DIR";
      else
        rm $CONFIG_DIR
      fi;;
    *   )
      echo "Installation Cancelled"; exit;;
  esac
fi

# Installing NVIM Config
if [ ! -d $CONFIG_DIR ]; then
  sudo apt update
  install_default
  sudo apt install -y neovim
  mkdir -p $CONFIG_DIR
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  cd $TMP_DIR && git clone https://github.com/s20016/nvim.git
  cp $TMP_DIR/nvim/conf/init.vim $CONFIG_DIR/.
  nvim +'PlugInstall --sync' +qa
  cp $TMP_DIR/nvim/conf/setting.vim $CONFIG_DIR/.
  cp $TMP_DIR/nvim/conf/mapping.vim $CONFIG_DIR/.
  cp $TMP_DIR/nvim/conf/plugins.vim $CONFIG_DIR/.
  mkdir $SESSIO_DIR
	gruvbox_tab
  nvim +'source $CONFIG_DIR/init.vim' +q
fi

nvim +'PlugInstall --sync' +qa
rm -rf $TMP_DIR

