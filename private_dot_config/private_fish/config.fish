set --export fish_color_autosuggestion 555

if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
     export LS_COLORS="$(vivid generate molokai)"
end


zoxide init fish | source

