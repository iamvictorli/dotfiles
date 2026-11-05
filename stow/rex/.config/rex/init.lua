-- Rex config migrated from Herdr (~/.config/herdr/config.toml) and Ghostty.
-- Bindings adapted from dmmulroy/.dotfiles (home/.config/rex/init.lua).
-- Reference: https://www.superlogical.com/rex/docs/reference/lua
-- After editing: rex config check && rex config reload
-- cmd+k keeps Rex's default (session picker).

-- Rex has no prefix mode; the prefix is the first key of a sequence.
-- Escape cancels a pending sequence.
local P = "ctrl+;>"

-- Herdr prefix ctrl+; : press it twice to send ctrl+; to the program.
rex.bind(P .. "ctrl+;", "pane.send_key", { key = "ctrl+;" })

-- App and sessions (Herdr: workspaces)
rex.bind(P .. "shift+/", "client.palette.toggle") -- herdr help = prefix+?
rex.bind(P .. "shift+s", "client.settings")
rex.bind(P .. "r", "client.config.reload")
rex.bind(P .. "s", "session.switch")
rex.bind(P .. "w", "session.switch")
rex.bind(P .. "g", "session.switch")
rex.bind(P .. "shift+n", "session.new")
rex.bind(P .. "shift+w", "session.rename")
rex.bind(P .. "shift+d", "session.close")
rex.bind(P .. "shift+9", "session.previous")
rex.bind(P .. "shift+0", "session.next")
rex.bind(P .. "b", "client.sidebar.toggle")

-- Tabs
rex.bind(P .. "c", "client.tab.new")
rex.bind(P .. ",", "client.tab.rename")
rex.bind(P .. "p", "client.tab.previous")
rex.bind(P .. "n", "client.tab.next")
for i = 1, 9 do
	rex.bind(P .. i, "client.tab.goto", { index = i })
end
rex.bind(P .. "shift+x", "client.tab.close")

-- Panes
rex.bind(P .. "\\", "pane.split", { direction = "right" })
rex.bind(P .. "enter", "pane.split", { direction = "down" })
rex.bind(P .. "x", "pane.close")
rex.bind(P .. "m", "pane.zoom")
rex.bind(P .. "tab", "pane.focus_next")
rex.bind(P .. "shift+tab", "pane.focus_previous")

-- Herdr focus_pane_* / swap_pane_* defaults. Rex moves the pane next to its
-- neighbour, which matches swap for two-pane rows/columns.
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	rex.bind(P .. key, "pane.focus", { direction = direction })
	rex.bind(P .. "shift+" .. key, "pane.move", { direction = direction })
end

-- Herdr copy_mode = prefix+v. Rex has no keyboard copy mode; find is closest.
rex.bind(P .. "v", "client.find.open")

-- Resize mode (Herdr resize_mode = prefix+shift+r). Exclusive modes swallow
-- unbound keys; escape exits unless rebound.
rex.mode("resize", { exclusive = true })
rex.bind(P .. "shift+r", "client.mode.enter", { name = "resize" })
for key, direction in pairs({
	h = "left",
	j = "down",
	k = "up",
	l = "right",
	left = "left",
	down = "down",
	up = "up",
	right = "right",
}) do
	rex.bind("resize/" .. key, "pane.resize", { direction = direction })
	rex.bind("resize/shift+" .. key, "pane.resize", { direction = direction, amount = 15 })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/escape", "client.mode.exit")

-- Vim-aware ctrl+h/j/k/l (Herdr: vim-herdr-navigation plugin).
-- When Vim/Neovim is in the foreground the key falls through to it. Otherwise
-- Rex moves focus; at the outer edge the key falls through so shell ctrl+l
-- (clear) still works.
local terminal = "com.superlogical.terminal"
local vim_names = { vi = true, vim = true, nvim = true, view = true, vimdiff = true, nvimdiff = true }

local function foreground_is_vim(ctx)
	local proc = rex.block.call(terminal, "process", { block_id = ctx.block_id })
	local fg = proc and proc.foreground
	if not fg then
		return false
	end
	-- `name` is not always the executable name, so check argv0 too.
	for _, s in ipairs({ fg.name or "", (fg.argv0 or ""):match("[^/]*$") or "" }) do
		if vim_names[s:lower()] then
			return true
		end
	end
	return false
end

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	rex.bind("ctrl+" .. key, function(ctx)
		if foreground_is_vim(ctx) then
			return false
		end
		local before = rex.session.view({})
		local after = rex.session.focus_direction({ direction = direction })
		-- Focus didn't move (outer edge): let the terminal have the key.
		return before ~= nil and after ~= nil and after.revision ~= before.revision
	end)
end
