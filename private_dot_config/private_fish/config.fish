set --export fish_color_autosuggestion 555

if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source

end


zoxide init fish | source

