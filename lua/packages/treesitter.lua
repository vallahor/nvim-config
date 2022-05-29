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
		"tsx",
		"zig",
		"jsonc",
		"css",
		"scss",
		"query",
		"rust",
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
			-- init_selection = "v",
			node_incremental = "v",
			node_decremental = "V",
			-- scope_incremental = "<c-/>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<c-5>"] = "@parameter.inner",
			},
			swap_previous = {
				["<c-4>"] = "@parameter.inner",
			},
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
