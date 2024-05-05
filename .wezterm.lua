-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "tokyonight_storm"
config.font = wezterm.font("Hack Nerd Font")

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true

config.colors = {
	cursor_bg = "#f0974c",
}

config.keys = {
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({
			key = "b",
			mods = "ALT",
		}),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
	{
		key = "1",
		mods = "CTRL",
		action = act.Multiple({
			act.SendKey({ key = "a", mods = "CTRL" }),
			act.SendKey({ key = "1" }),
		}),
	},
	{
		key = "2",
		mods = "CTRL",
		action = act.Multiple({
			act.SendKey({ key = "a", mods = "CTRL" }),
			act.SendKey({ key = "2" }),
		}),
	},
	{
		key = "3",
		mods = "CTRL",
		action = act.Multiple({
			act.SendKey({ key = "a", mods = "CTRL" }),
			act.SendKey({ key = "3" }),
		}),
	},
	{
		key = "4",
		mods = "CTRL",
		action = act.Multiple({
			act.SendKey({ key = "a", mods = "CTRL" }),
			act.SendKey({ key = "4" }),
		}),
	},
	{
		key = "5",
		mods = "CTRL",
		action = act.Multiple({
			act.SendKey({ key = "a", mods = "CTRL" }),
			act.SendKey({ key = "5" }),
		}),
	},
}

config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
	regex = [[(KP-\d+)]],
	format = "https://siajira.sq.com.sg:8080/browse/$1",
})
config.debug_key_events = true
-- and finally, return the configuration to wezterm
return config
