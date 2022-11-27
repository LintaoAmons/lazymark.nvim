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
	if #markStrings == 0 then
		vim.notify("No bookmark yet")
		return
	end
	local parsedMark = MarkString.parse(markStrings[#markStrings])
	vim.cmd(":e " .. parsedMark.filename)
	vim.api.nvim_win_set_cursor(0, parsedMark.location)
end

M.undoMark = function()
	local markHistory = getDoMarkHistory()
	if #markHistory == 0 then
		vim.notify("Can't rollback, no more mark history")
		return
	end

	local rollbacked = { table.unpack(markHistory, 1, #markHistory - 1) }
	FsUtils.writeFileSync(getDoMarkHistoryPath(), rollbacked)

	FsUtils.appendFileSync(getUndoMarkHistoryPath(), markHistory[#markHistory])
end

M.redoMark = function()
	local undoHistory = FsUtils.readFile(getUndoMarkHistoryPath())
	if #undoHistory == 0 then
		vim.notify("No more undo history")
		return
	end

	local undoHistoryNew = { table.unpack(undoHistory, 1, #undoHistory - 1) }
	FsUtils.writeFileSync(getUndoMarkHistoryPath(), undoHistoryNew)

	FsUtils.appendFileSync(getDoMarkHistoryPath(), undoHistory[#undoHistory])
end

M.mark = function()
	local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	saveMark(row, col)
end

return M
