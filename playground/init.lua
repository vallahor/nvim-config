local fn = vim.fn

function _G.put(args)
	vim.pretty_print(args)
end

local linenr = fn.line(".")
local colnr = fn.virtcol(".")

function MatchesList(ch)
	-- local lines = fn.getline(fn.line("w0"), linenr)
	local lines = fn.getline(linenr, fn.line("w$"))

	local matches = {}

	-- traverse list of lines
	for index, line in ipairs(lines) do
		-- traverse each line and checking if find some match
		for col = colnr, #line do
			if line:sub(col, col) == ch then
				table.insert(matches, { line = linenr + index - 1, col = col })
			end
		end
	end

	return matches
end

local input = fn.input("")
local matches = MatchesList(input)

function SeekForward(matches_list)
	for _, match in ipairs(matches_list) do
		put(match)
		if colnr < match.col then
			fn.cursor(match.line, match.col)
			break
		end
	end
end

function SeekBackward(matches_list)
	local matches_reversed = fn.reverse(matches_list)
	for _, match in ipairs(matches_reversed) do
		if colnr > match.col then
			fn.cursor(match.line, match.col)
			break
		end

		fn.cursor(match.line, match.col)
	end
end

SeekForward(matches)
-- SeekBackward(matches)
