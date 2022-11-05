local M = {}

local commands = {
	{
		name = "Lazymark",
		callback = M.mark,
	},
	{
		name = "LazymarkGoToMark",
		callback = M.gotoMark,
	},
	{
		name = "LazymarkCheckCurrentMark",
		callback = M.check,
	},
}

local function initCommands()
	for _, v in ipairs(commands) do
		vim.api.nvim_create_user_command(v.name, v.callback, {})
	end
end

local markPersistency = vim.fn.stdpath("cache") .. "/lazymark.nvim"

local function getRawMark()
	return vim.fn.readfile(markPersistency)[1]
end

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

local function isMarkExists(rawMark)
	if string.len(rawMark) > 0 then
		return true
	end
	return false
end

local function markCurrentLocation()
	local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	local abspath = vim.api.nvim_buf_get_name(0)
	local mark = abspath .. "|" .. row .. "," .. col
	vim.cmd(":call writefile" .. '(["' .. mark .. '"],"' .. markPersistency .. '")')
end

M.check = function()
	vim.notify(vim.inspect(parseMark(getRawMark())))
end

M.gotoMark = function()
	local rawMark = getRawMark()
	local parsedMark = parseMark(rawMark)
	vim.cmd(":e " .. parsedMark.filename)
	vim.api.nvim_win_set_cursor(0, parsedMark.location)
end

M.mark = function()
	local rawMark = getRawMark()
	if isMarkExists(rawMark) then
		vim.ui.input({
			prompt = "Sure to overwrite current mark? y/N",
		}, function(userChoose)
			if userChoose == "y" then
				markCurrentLocation()
				vim.notify("Preview mark at: " .. rawMark .. " is overwrited")
			end
		end)
	else
		markCurrentLocation()
	end
end

initCommands()

return M
