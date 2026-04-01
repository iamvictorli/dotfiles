--- @since 26.1.22

-- Match Yazi's built-in remove target selection: selected files, or hovered file.
local selected_or_hovered = ya.sync(function()
	local tab, urls = cx.active, {}
	for _, url in pairs(tab.selected) do
		urls[#urls + 1] = url
	end
	if #urls == 0 and tab.current.hovered then
		urls[1] = tab.current.hovered.url
	end
	return urls
end)

local function notify(level, content)
	ya.notify {
		title = "Trash",
		content = content,
		level = level,
		timeout = 5,
	}
end

local function confirm_title(n)
	return string.format("Trash %d selected file%s?", n, n == 1 and "" or "s")
end

return {
	entry = function()
		local urls = selected_or_hovered()
		if #urls == 0 then
			return notify("warn", "No file selected")
		end

		local ok = ya.confirm {
			pos = { "center", w = 70, h = 20 },
			title = confirm_title(#urls),
			body = "This will send the selected files to Trash using trash-cli.",
		}
		if not ok then
			return
		end

		-- Pass concrete filesystem paths to trash-cli.
		local paths = {}
		for _, url in ipairs(urls) do
			paths[#paths + 1] = tostring(url)
		end

		local output, err = Command("trash"):arg(paths):output()
		if not output then
			return notify("error", string.format("Failed to run trash: %s", err))
		elseif not output.status.success then
			local stderr = output.stderr:gsub("^%s+", ""):gsub("%s+$", "")
			if stderr == "" then
				stderr = "trash exited with a non-zero status"
			end
			return notify("error", stderr)
		end

		-- Clear selection state and force a redraw after the external trash command.
		ya.emit("escape", { select = true, visual = true })
		ya.emit("refresh", {})
	end,
}
