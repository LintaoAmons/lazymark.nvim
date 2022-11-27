local M = {}

local uv = vim.loop

M.initDir = function(path)
	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, "p")
	end
end

M.appendFileSync = function(path, content)
	local fd = assert(uv.fs_open(path, "a", 438))
	local data = assert(uv.fs_write(fd,content))
	assert(uv.fs_close(fd))
	return data
end

return M
