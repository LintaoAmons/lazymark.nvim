local MarkString = require("lazymark.mark-string")
local FsUtils = require("lazymark.fs-utils")

local M = {}

table.unpack = table.unpack or unpack

local config = vim.g.lazymark_settings

local function getDoMarkHistoryPath()
	return vim.g.lazymark_settings.persist_mark_dir .. "/doMarkHistory"
end

local function getUndoMarkHistoryPath()
	return vim.g.lazymark_settings.persist_mark_dir .. "/undoMarkHistory"
end

local function getDoMarkHistory()
	return FsUtils.readFile(getDoMarkHistoryPath())
end

local function saveMark(row, col)
	FsUtils.initDir(config.persist_mark_dir)
	local markString = MarkString.build(vim.api.nvim_buf_get_name(0), row, col)
	FsUtils.appendFileSync(getDoMarkHistoryPath(), markString)
end

M.gotoMark = function()
	local markStrings = getDoMarkHistory()
	local parsedMark = MarkString.parse(markStrings[#markStrings])
	vim.cmd(":e " .. parsedMark.filename)
	vim.api.nvim_win_set_cursor(0, parsedMark.location)
end

M.rollbackMark = function()
	local markStrings = getDoMarkHistory()
	if #markStrings == 0 then
		vim.notify("Can't rollback, no more mark history")
	end

	FsUtils.writeFileSync(io.open(getDoMarkHistoryPath()), markStrings)
end

M.mark = function()
	local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	saveMark(row, col)
end

return M
