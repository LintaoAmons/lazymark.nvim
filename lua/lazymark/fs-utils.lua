local M = {}

local uv = vim.loop

M.initDir = function(path)
	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, "p")
	end
end

M.readFileSync = function(path)
	local fd = assert(uv.fs_open(path, "r", 438))
	local stat = assert(uv.fs_fstat(fd))
	local data = assert(uv.fs_read(fd, stat.size, 0))
	assert(uv.fs_close(fd))
	return data
end

M.appendFileSync = function(path)
	local fd = assert(uv.fs_open(path, "a", 438))
	local data = assert(uv.fs_write(fd, "test_content"))
	assert(uv.fs_close(fd))
	return data
end

return M
