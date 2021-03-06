local ok, nvim_treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end
nvim_treesitter.setup({
	ensure_installed = {
		"lua",
		"c",
		"cpp",
		"javascript",
		"typescript",
		"zig",
		"jsonc",
		"query",
		"python",
		"rust",
		"c_sharp",
	},
	highlight = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	indent = {
		enable = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			-- init_selection = "m",
			node_incremental = "v",
			node_decremental = "V",
			scope_incremental = "<c-/>",
		},
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25,
		persist_queries = false,
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
})

require("nvim-treesitter.highlight").set_custom_captures({
	["js.named_import"] = "TSLiteral",
	["js.import"] = "TSLiteral",
	["js.keyword"] = "TSOperator",
	["js.keyword_bold"] = "TSInclude",
	["js.arrow_func"] = "TSKeyword",
	["js.opening_element"] = "TSElement",
	["js.closing_element"] = "TSElement",
	["js.self_closing_element"] = "TSElement",
	["zig.assignop"] = "TSOperator",
})
