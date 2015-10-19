# vi: set ft=sh :

set -x EDITOR (which nvim)
set -x FISH_CONFIG (readlink "$HOME/.config/fish/config.fish")

function fish_user_key_bindings
  fish_vi_key_bindings
end

function current_branch
  echo (git branch ^/dev/null | grep \* | sed 's/* //')
end

function has_background_jobs
  if [ '1' = (jobs | wc -l | sed 's/ //g') ]; return 0; else; return 1; end;
end

function fish_prompt
  python ~/powerline-shell.py $status --shell bare ^/dev/null
end

###################
# Git
###################

alias ga 'git add'
alias gc 'git commit'
alias gs 'git status'
alias gd 'git diff'
alias co 'git checkout'
alias gl 'git pull'
alias pull 'git pull origin (current_branch)'
alias push 'git push origin (current_branch)'
alias fpush 'git push origin +(current_branch)'

###################
# NPM
###################

alias npmi 'npm install'
alias npmS 'npm install --save'
alias npmD 'npm install --save-dev'
alias npmG 'npm install -g'

###################
# Ctags
###################

alias ctag-project 'ctags -R -f .tags .'
alias ctag-gems 'ctags -R -f .gemtags (bundle list --paths)'

###################
# Rubby
###################

alias bi 'bundle install'
alias be 'bundle exec'
alias rt 'bundle exec ruby -Itest'

###################
# Vagrant
###################

alias vu 'cd ~/Code/vagrant; and vagrant up'
alias vm 'cd ~/Code/vagrant; and vagrant mosh'
alias vs 'cd ~/Code/vagrant; and vagrant ssh'

###################
# Utilities
###################

alias serve 'python -m SimpleHTTPServer'
alias vim 'nvim'


# Heroku, RVM
set -x PATH "/usr/local/heroku/bin" $PATH "$HOME/.rvm/bin"
# NVM
# set -x NVM_DIR "$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ]; and . "$NVM_DIR/nvm.sh"
