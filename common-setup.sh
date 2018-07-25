#! /bin/sh

echo "Starting common-startup"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this file has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

chsh -s /usr/local/bin/fish

vim +BundleInstall +qall

# Install fonts
echo "Installing powerline patched fonts"
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ../
rm -rf fonts

# ln -s "$HOME/.vimrc" "$HOME/.nvimrc"
# ln -s "$HOME/.vim" "$HOME/.nvim"

# Install powerline
# echo "Installing powerline-shell"
# cd powerline-shell
# python ./install.py
# ln -s $(pwd)/powerline-shell.py ~/powerline-shell.py
# cd ..
# echo "Completed common-setup"
