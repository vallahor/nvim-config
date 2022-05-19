local ok, tabline = pcall(require, "tabline_framework")
if not ok then
	return
end

local render = function(f)
	f.make_bufs(function(info)
		f.add(" " .. info.index .. " ")

		if info.filename then
			f.add(info.filename)
			f.add(info.modified and "[+]")
		else
			f.add(info.modified and "[+]" or "[-]")
		end

		f.add(" ")
	end)
end

tabline.setup({
	render = render,
	--
	-- hl = { fg = "#abb2bf", bg = "#31353f" },
	-- hl_sel = { fg = "#282c34", bg = "#abb2bf" },
	-- hl_fill = { fg = "#282c34", bg = "#abb2bf" },
})
