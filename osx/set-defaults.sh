# Show hidden files
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

# Install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install homebrew stuffs
brew install git the_silver_searcher

# Install fonts
git clone https://github.com/powerline/fonts.git
cd fonts/
./install.sh
cd ../ && rm -rf fonts
