-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Brogrammer'

config.font = wezterm.font('CommitMono')
config.harfbuzz_features = { 'ss03=1, ss04=1, ss05=1, cv08=1, calt=1, dlig=1' }
config.font_size = 13
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 110
config.initial_rows = 30
front_end = 'WebGpu'
config.default_cursor_style = 'SteadyBar'
config.hide_mouse_cursor_when_typing = true
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 150,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 150,
}
config.colors = {
visual_bell = '#202020',
}
-- and finally, return the configuration to wezterm
return config
