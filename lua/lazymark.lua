local M = {}

local markPersistency = vim.fn.stdpath("cache") .. "/lazymark.nvim"

M.setup = function()
  print("Hello lazymark")
end

M.mark = function()
  print("start mark")
  local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  print(row, col)
  local abspath = vim.api.nvim_buf_get_name(0)
  local mark = abspath .. "|" .. row .. "," .. col
  print(mark)
  vim.cmd(":call writefile" .. '(["' .. mark .. '"],"' .. markPersistency .. '")')
end

local commands = {
  {
    name = "Lazymark",
    callback = M.mark,
  },
}

for _, v in ipairs(commands) do
  print("setup commands")
  vim.api.nvim_create_user_command(v.name, v.callback, {})
end

return M
