-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local server_id_file = "/tmp/nvim-focuslost"

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
		key = "Enter",
		mods = "CTRL",
		action = act.Multiple({
			act.SendKey({ key = "a", mods = "CTRL" }),
			act.SendKey({ key = "z" }),
		}),
	},
	{
		key = "r",
		mods = "CMD",
		action = act.Multiple({
			act.SendKey({ key = "a", mods = "CTRL" }),
			act.SendKey({ key = "t" }),
		}),
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

local function extract_filename(uri)
	local start, match_end = uri:find("$EDITOR:")
	if start == 1 then
		-- skip past the colon
		return uri:sub(match_end + 1)
	end

	-- `file://hostname/path/to/file`
	local start, match_end = uri:find("file:")
	if start == 1 then
		-- skip "file://", -> `hostname/path/to/file`
		local host_and_path = uri:sub(match_end + 3)
		local start, match_end = host_and_path:find("/")
		if start then
			-- -> `/path/to/file`
			return host_and_path:sub(match_end)
		end
	end

	return nil
end

local function get_nvim_server_id()
	local file = io.open(server_id_file)
	local server_id = file:read("*l")
	local windowId = file:read("*l")
	local paneId = file:read("*l")
	local vimcwd = file:read("*l")
	-- server_id = server_id:sub(1, -2)

	return { server_id = server_id, paneId = paneId, windowId = windowId, vimcwd = vimcwd }
end

local function get_pwd(pane)
	local pwd = pane:get_current_working_dir()
	local info = pane:get_foreground_process_info()
	print(info)
	pwd = string.gsub(pwd.file_path, "^file://[^/]+", "")
	return pwd
end

local function extract_line_and_name(uri)
	local name = extract_filename(uri)

	if name then
		local line = 1
		-- check if name has a line number (e.g. `file:.../file.txt:123 or file:.../file.txt:123:456`)
		local start, match_end = name:find(":[0-9]+")
		if start then
			-- line number is 123
			line = name:sub(start + 1, match_end)
			-- remove the line number from the filename
			name = name:sub(1, start - 1)
		end

		return line, name
	end

	return nil, nil
end

local function open_in_nvim(name, line, window, pane)
	local server_id = get_nvim_server_id().server_id
	local windowId = get_nvim_server_id().windowId
	local paneId = get_nvim_server_id().paneId
	local vimcwd = get_nvim_server_id().vimcwd
	local full_path
	if name then
		if string.sub(name, 1, 1) ~= "/" then
			full_path = vimcwd .. "/" .. name
		end
		print(full_path)
		-- print(server_id)
		-- print(tostring(windowId))
		-- print(paneId)
		wezterm.run_child_process({ "/opt/homebrew/bin/nvr", "--servername", server_id, full_path, "-c", line })
		window:perform_action(
			act.Multiple({
				act.SendKey({ key = "a", mods = "CTRL" }),
				act.SendKey({ key = tostring(windowId) }),
			}),
			pane
		)
		return true
	end
	-- os.execute("tmux select-window -t " .. windowId)
	-- os.execute("tmux select-pane -t " .. paneId)
	-- wezterm.run_child_process({ "tmux", "select-window", "-t", windowId })
	-- wezterm.run_child_process({ "tmux", "select-pane", "-t", paneId })
end

-- Listen for the "open-uri" escape sequence and open the URI in
wezterm.on("open-uri", function(window, pane, uri)
	local line, name = extract_line_and_name(uri)

	local opened = open_in_nvim(name, line, window, pane)
	if opened then
		return false
	end
	-- if email
	if uri:find("mailto:") == 1 then
		return false -- disable opening email
	end
end)

-- config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.hyperlink_rules = {
	-- These are the default rules, but you currently need to repeat
	-- them here when you define your own rules, as your rules override
	-- the defaults

	-- URL with a protocol
	{
		regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
		format = "$0",
	},

	-- implicit mailto link
	{
		regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
		format = "mailto:$0",
	},

	-- new in nightly builds; automatically highly file:// URIs.
	{
		regex = "\\bfile://\\S*\\b",
		format = "$0",
	},

	-- Now add a new item at the bottom to match things that are
	-- probably filenames
	{
		regex = "[/.A-Za-z0-9_-]+\\.[A-Za-z0-9]+(:\\d+)*(?=\\s*|$)",
		format = "$EDITOR:$0",
	},
}

table.insert(config.hyperlink_rules, {
	regex = [[(KP-\d+)]],
	format = "https://siajira.sq.com.sg:8080/browse/$1",
})
-- config.debug_key_events = true
-- and finally, return the configuration to wezterm
return config
