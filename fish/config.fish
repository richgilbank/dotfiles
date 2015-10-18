# vi: set ft=sh :

set -x EDITOR (which vim)
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

function fish_prompt --description 'Write out the prompt'
  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  if not set -q __git_cb
    set __git_cb ":"(set_color brown)(current_branch)(set_color normal)""
  end

  if not set -q __fish_prompt_cwd
    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
  end

  if has_background_jobs and not set -q __has_background_jobs
    set -g __has_background_jobs (set_color $fish_color_end)' ☂ '(set_color normal)
  else
    set -g __has_background_jobs ''
  end

  printf '%s%s%s%s%s> ' $__fish_prompt_cwd (prompt_pwd) $__fish_prompt_normal $__git_cb $__has_background_jobs
end

###################
# Git
###################

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
# Utilities
###################

alias serve 'python -m SimpleHTTPServer'

###################
# Rubby
###################

alias bi 'bundle install'
alias be 'bundle exec'
alias rt 'bundle exec ruby -Itest'

# Heroku, RVM
set -x PATH "/usr/local/heroku/bin" $PATH "$HOME/.rvm/bin"
# NVM
# set -x NVM_DIR "$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ]; and . "$NVM_DIR/nvm.sh"
