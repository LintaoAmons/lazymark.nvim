local M = {}

local commands = {
	{
		name = "Lazymark",
		callback = M.mark,
	},
	{
		name = "LazymarkGoToMark",
		callback = M.goToMark,
	},
}

local markPersistency = vim.fn.stdpath("cache") .. "/lazymark.nvim"

local function parseMark(mark)
	local parsedResult = {}
	for filename, position in string.gmatch(mark, "(.+)|(.+)") do
		parsedResult.filename = filename
		for row, col in string.gmatch(position, "(.+),(.+)") do
			local rowCol = {}
			table.insert(rowCol, tonumber(row))
			table.insert(rowCol, tonumber(col))
			parsedResult.location = rowCol
		end
	end
	return parsedResult
end

M.goToMark = function()
	local persistedMark = vim.fn.readfile(markPersistency)[1]
	local parsedMark = parseMark(persistedMark)
	vim.cmd(":e " .. parsedMark.filename)
	vim.api.nvim_win_set_cursor(0, parsedMark.location)
end

M.mark = function()
	local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	local abspath = vim.api.nvim_buf_get_name(0)
	local mark = abspath .. "|" .. row .. "," .. col
	vim.cmd(":call writefile" .. '(["' .. mark .. '"],"' .. markPersistency .. '")')
end

for _, v in ipairs(commands) do
	print("setup commands")
	vim.api.nvim_create_user_command(v.name, v.callback, {})
end

return M
