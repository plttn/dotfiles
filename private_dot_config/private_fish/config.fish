#set -g EZA_CONFIG_DIR "$HOME/.config/eza"

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx LS_COLORS (vivid generate molokai)

end

# eval "$(atuin hex init)"
# zoxide is set up by the zoxide.fish plugin

set --export EXA_COLORS "da=1;34"
set --export BAT_THEME "Monokai Extended Origin"
set --export GOPATH "$HOME/go"
set --export CLAUDE_CODE_PLUGIN_PREFER_HTTPS 1

# The following lines were added by Docker Desktop to add commands to your PATH.
set -gx PATH $PATH "$HOME/.docker/bin"
# End of Docker Desktop section.

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

test -f ~/.config/op/plugins.sh; and source ~/.config/op/plugins.sh

scheme set monokai
~/.local/bin/mise activate fish | source
direnv hook fish | source
set -g fish_transient_prompt 1
fish_default_key_bindings

set -g tide_jj_show_description false

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Added by LM Studio CLI (lms)
set -gx PATH $PATH "$HOME/.lmstudio/bin"
# End of LM Studio CLI section
projj shell-setup fish | source    # fish

if status is-interactive
    atuin init fish | source
end
