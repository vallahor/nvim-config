local ok, marks = pcall(require, "marks")

if not ok then
	return
end

marks.setup({
	mappings = {
		set = "<c-space>",
		set_next = "<c-space><c-space>",
		delete = "d<c-space>",
		delete_buf = "<c-space><c-d>",
		-- prev = "<c-;>",
		-- next = "<c-'>",
	},
})
