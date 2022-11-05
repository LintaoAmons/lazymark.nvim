local M = {}

local markPersistency = vim.fn.stdpath("cache") .. "/lazymark.nvim"

M.setup = function()
  print("Hello lazymark")
end

M.mark = function()
  local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  local abspath = vim.api.nvim_buf_get_name(0)
  local mark = abspath .. "|" .. row .. "," .. col
  vim.cmd(":call writefile" .. '(["' .. mark .. '"],"' .. markPersistency .. '")')
end

return M
