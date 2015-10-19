#! /bin/sh

echo "Starting Linux set-defaults"

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim

apt-get -y install fish silversearcher-ag exuberant-ctags

chsh -s /usr/bin/fish
