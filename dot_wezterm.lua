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


config.font = wezterm.font('TX-02')

config.harfbuzz_features = { 'calt=0' }
onfig.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 115
config.initial_rows = 35
front_end = 'WebGpu'
config.default_cursor_style = 'SteadyUnderline'
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
