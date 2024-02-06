set --export fish_color_autosuggestion 555

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

source ~/.asdf/asdf.fish

# starship init fish | source
