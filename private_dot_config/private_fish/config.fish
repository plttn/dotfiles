# set --export fish_color_autosuggestion 555
#set -g tide_right_prompt_suffix " "

set -g EZA_CONFIG_DIR "$HOME/.config/eza"

if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source

    export LS_COLORS="$(vivid generate molokai)"

end

zoxide init fish | source


# pnpm
set -gx PNPM_HOME "/Users/jack/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# source ~/.asdf/asdf.fish
# direnv hook fish | source

#abbr --position command kssh "kitten ssh"

#starship init fish | source

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true
/Users/jack/.local/bin/mise activate fish | source

scheme set monokai