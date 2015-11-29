Rich's dotfiles
==================
My vim/zsh dotfiles, derived from / inspired by these people:
- [Shane Jonas](https://github.com/shanejonas/dotfiles)
- [Michael Russo](https://github.com/mjrusso/dotfiles)
- [Zach Holman   ](https://github.com/holman/dotfiles)
- [Mathias Bynens](https://git   hub.com/mathiasbynens/dotfiles)

installation
------------

    git clone git@github.com:richgilbank/dotfiles.git
    cd dotfiles
    rake install
    set your iterm colors and fonts
      * Profiles > Colors > Load Preset > Solarized Dark
      * Profiles > Text > Regular Font > Change Font > "Source Code Pro for Powerline"
      * Profiles > Text > Non-ASCII Font > Change Font > "Source Code Pro for Powerline"
    if things didn't all work, you may have to run './common-setup.sh' manually

notes
-----

- **bin/**: Anything in `bin/` will be added to your `$PATH` and be made
  available everywhere.

- **topic/\*.sh**: Any files ending in `.sh` get loaded into your environment.

- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. (These files get symlinked when you run `rake install`.)

  - symlinks can be generated in cases where these standard **topic/\*.symlink**
  symlink rules do not apply; see the `:install` task of the `Rakefile` for details.

- **.localrc**: Create a file called `.localrc` to store any data that you do
  not want committed to the git repository (secrets, etc.).
