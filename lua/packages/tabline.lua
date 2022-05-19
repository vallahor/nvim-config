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

	hl = { fg = "#C0AEA0", bg = "#222022" },
	hl_sel = { fg = "#C0AEA0", bg = "#3d3339" },
	hl_fill = { fg = "#C0AEA0", bg = "#222022" },
})
