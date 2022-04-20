require 'lspconfig'.cssmodules_ls.setup {}

require 'lspconfig'.eslint.setup {}

require 'lspconfig'.tsserver.setup {}

require 'lspconfig'.prismals.setup {}

require 'lspconfig'.sumneko_lua.setup {}

require 'lspconfig'.html.setup {}

vim.cmd [[ au BufWritePre *.lua lua vim.lsp.buf.formatting_sync() ]]
vim.cmd [[ au BufWritePre *.html lua vim.lsp.buf.formatting_sync() ]]
vim.cmd [[ au BufWritePre *.css,*.scss lua vim.lsp.buf.formatting_sync() ]]
vim.cmd [[ au BufWritePre *.tsx,*.ts,*.jsx,*.js lua vim.lsp.buf.formatting_sync() ]]
