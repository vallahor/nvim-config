return {
	-- "dense-analysis/ale",
	"hbarcelos/ale", -- hes version works with solc
	config = function()
		vim.cmd([[
	               let g:ale_linters = {
                   \   'solidity': ['solc'],
                   \   'python': ['ruff'],
	               \}
                   let g:ale_solidity_solc_options = '--include-path node_modules/ --base-path .'

                   " let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

	               let g:ale_lint_on_enter = 1
	               " let g:ale_lint_on_save = 1
	               let g:ale_lint_on_text_changed = 1
	               let g:ale_lint_on_insert_leave = 1
	               let g:ale_linters_explicit = 1
	               let g:ale_warn_about_trailing_whitespace = 0
	               let g:ale_use_neovim_diagnostics_api = 1
                   let g:ale_hover_cursor = 0
	           ]])
	end,
}
