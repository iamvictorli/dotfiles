local M = {}

local state = ya.sync(function()
	return cx.active.current.cwd
end)

function M:entry()
	ya.emit("escape", { visual = true })

	local cwd = state()
	if cwd.scheme.is_virtual then
		return ya.notify { title = "Dirs fzf", content = "Not supported under virtual filesystems", timeout = 5, level = "warn" }
	end

	local permit = ui.hide()
	local output, err = M.run_with(cwd)
	permit:drop()

	if not output then
		return ya.notify { title = "Dirs fzf", content = tostring(err), timeout = 5, level = "error" }
	end

	local dir = output:gsub("[\r\n]+$", "")
	if dir == "" then
		return
	end

	local url = Url(dir)
	if not url.is_absolute then
		url = cwd:join(dir)
	end

	ya.emit("cd", { url, raw = true })
end

function M.run_with(cwd)
	local script = [[
		if command -v fd >/dev/null 2>&1; then
			fd --type d --strip-cwd-prefix
		elif command -v fdfind >/dev/null 2>&1; then
			fdfind --type d --strip-cwd-prefix
		else
			find . -type d | sed 's#^./##' | sed '/^\.$/d'
		fi | fzf --no-multi
	]]

	local child, err = Command("sh")
		:arg({ "-c", script })
		:cwd(tostring(cwd))
		:stdout(Command.PIPED)
		:spawn()

	if not child then
		return nil, Err("Failed to start directory fzf, error: %s", err)
	end

	local output, wait_err = child:wait_with_output()
	if not output then
		return nil, Err("Cannot read fzf output, error: %s", wait_err)
	elseif not output.status.success and output.status.code ~= 130 then
		return nil, Err("fzf exited with error code %s", output.status.code)
	end

	return output.stdout, nil
end

return M
