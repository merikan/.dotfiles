--- @sync entry
local M = {}

-- Yazi's first cd at startup goes to the path argument, or $PWD if none was given
function M:setup()
	ps.sub("cd", function()
		if not self.start_dir then
			self.start_dir = tostring(cx.active.current.cwd) -- a Url is consumed by the first ya.emit
		end
	end)
end

-- No args: create a tab in the start directory.
-- With a tab index: create missing tabs up to it in the start directory, then switch to it.
function M:entry(job)
	local idx = job.args[1]
	if idx == nil then
		ya.emit("tab_create", { self.start_dir })
		return
	end

	for _ = #cx.tabs, idx do
		ya.emit("tab_create", { self.start_dir })
	end
	ya.emit("tab_switch", { idx })
end

return M
