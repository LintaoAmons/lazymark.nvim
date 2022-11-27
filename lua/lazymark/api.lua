local MarkString = require("lazymark.mark-string")
local FsUtils = require("lazymark.fs-utils")

local M = {}

table.unpack = table.unpack or unpack

local config = vim.g.lazymark_settings

local do_mark_history = vim.g.lazymark_settings.persist_mark_dir .. "/doMarkHistory"

local undo_mark_history = vim.g.lazymark_settings.persist_mark_dir .. "/undoMarkHistory"

local function getDoMarkHistory()
	return vim.fn.readfile(do_mark_history)[1]
end

local function addMark(row, col)
	FsUtils.initDir(config.persist_mark_dir)

	local markString = MarkString.build(vim.api.nvim_buf_get_name(0), row, col)
	-- todo: append new mark in last line of file
	vim.cmd(":call writefile" .. '(["' .. markString .. '"],"' .. do_mark_history .. '")')
end

M.gotoMark = function()
	local markString = getDoMarkHistory()
	local parsedMark = MarkString.parse(markString)
	vim.cmd(":e " .. parsedMark.filename)
	vim.api.nvim_win_set_cursor(0, parsedMark.location)
end

M.mark = function()
	local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	addMark(row, col)
end

return M
