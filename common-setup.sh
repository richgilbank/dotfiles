vim +BundleInstall +qall

# Install fonts
git clone https://github.com/powerline/fonts.git
cd fonts/
./install.sh
cd ../ && rm -rf fonts

# Install powerline
cd powerline-shell
python ./install.py
ln -s (pwd)/powerline-shell.py ~/powerline-shell.py
cd ..
