set -x DOTFILES $HOME/.dotfiles
set -x PATH /usr/local/share/python /usr/local/bin /usr/local/sbin $DOTFILES/bin $PATH
set -x MANPATH /usr/local/man /usr/local/mysql/man /usr/local/git/man $MANPATH
set -x EDITOR /usr/local/bin/emacsclient

# Adapted from http://notsnippets.tumblr.com/post/894091013/fish-function-of-the-day-prompt-with-git-branch
function fish_prompt --description 'Write out the prompt'

    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __git_cb
        set __git_cb ":"(set_color brown)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)""
    end

    switch $USER

        case root

        if not set -q __fish_prompt_cwd
            if set -q fish_color_cwd_root
                set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
            else
                set -g __fish_prompt_cwd (set_color $fish_color_cwd)
            end
        end

        printf '⚡⚡ %s@%s:%s%s%s%s# ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" $__git_cb

        case '*'

        if not set -q __fish_prompt_cwd
            set -g __fish_prompt_cwd (set_color $fish_color_cwd)
        end

        printf '⚡⚡ %s@%s:%s%s%s%s$ ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" $__git_cb

    end
end
