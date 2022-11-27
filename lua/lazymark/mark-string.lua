local M = {}

-- parsedMark example:
-- {
--   filename = "/Users/lintao.zhang/.config/nvim/lua/user/my-plugin/init.lua",
--   location = { 30, 4 }
-- }
M.parse = function(markString)
	local parsedMark = {}
	for filename, position in string.gmatch(markString, "(.+)|(.+)") do
		parsedMark.filename = filename
		for row, col in string.gmatch(position, "(.+),(.+)") do
			local rowCol = {}
			table.insert(rowCol, tonumber(row))
			table.insert(rowCol, tonumber(col))
			parsedMark.location = rowCol
		end
	end
	return parsedMark
end

-- markString example:
-- /Users/lintao.zhang/.config/nvim/lua/user/my-plugin/init.lua|30,4
M.build = function(abspath, row, col)
	return abspath .. "|" .. row .. "," .. col .. "\n"
end

return M
