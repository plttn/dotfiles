if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

op completion fish | source
starship init fish | source
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

