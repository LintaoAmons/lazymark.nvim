local M = {}

local uv = vim.loop

M.initDir = function(path)
	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, "p")
	end
end

M.readFile = function(path)
	return vim.fn.readfile(path)
end

M.writeFileSync = function(path, lines)
	local fd = assert(io.open(path, "w"))
	for _, value in ipairs(lines) do
		fd:write(value .. "\n")
	end
	fd:close()
end

M.appendFileSync = function(path, content)
	local fd = assert(uv.fs_open(path, "a", 438))
	local data = assert(uv.fs_write(fd, content))
	assert(uv.fs_close(fd))
	return data
end

return M
