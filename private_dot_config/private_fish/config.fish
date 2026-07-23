#set -g EZA_CONFIG_DIR "$HOME/.config/eza"

if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
    set -gx LS_COLORS (vivid generate molokai)

end

# eval "$(atuin hex init)"
#zoxide init fish | source
# pnpm
# set -gx PNPM_HOME "/Users/jack/Library/pnpm"
# if not string match -q -- $PNPM_HOME $PATH
#   set -gx PATH "$PNPM_HOME" $PATH
# end
# pnpm end

scheme set monokai
~/.local/bin/mise activate fish | source
set -g fish_transient_prompt 1
fish_default_key_bindings

set -g tide_jj_show_description false

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/jack/.lmstudio/bin
# End of LM Studio CLI section
projj shell-setup fish | source    # fish
