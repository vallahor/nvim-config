return {
    {
        "neoclide/coc.nvim",
        branch = "release",
        build = "yarn install --frozen-lockfile",
        config = function()
            vim.keymap.set("n", "gd", "<Plug>(coc-definition)")
            -- vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)")
            -- vim.keymap.set("n", "gi", "<Plug>(coc-implementation)")
            vim.keymap.set("n", "<c-2>", "<Plug>(coc-rename)")
            vim.keymap.set("n", "<c-1>", "<Plug>(coc-code_action-cursor)")
            vim.keymap.set("n", "<c-3>", "<Plug>(coc-references)")

            vim.keymap.set("n", "<a-d>", "<Plug>(coc-diagnostic-info)")

            vim.keymap.set("i", "<c-;>", "<Plug>(coc-snippets-expand-jump)")
            vim.keymap.set("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })
            vim.keymap.set("n", "<a-[>", "<Plug>(coc-diagnostic-prev)")
            vim.keymap.set("n", "<a-]>", "<Plug>(coc-diagnostic-next)")

            local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
            vim.keymap.set("i", "<c-j>", 'coc#pum#visible() ? coc#pum#next(1) : "<c-j>"', opts)
            vim.keymap.set("i", "<c-k>", 'coc#pum#visible() ? coc#pum#prev(1) : "<c-k>"', opts)
            vim.keymap.set("i", "<tab>", 'coc#pum#visible() ? coc#_select_confirm() : "<C-g>u<CR>"', opts)

            vim.keymap.set("n", "<a-->", "<cmd>set cmdheight=0<cr>")

            vim.keymap.set(
                "n",
                "<f8>",
                "<cmd>CocInstall coc-json coc-tsserver coc-eslint coc-prettier @nomicfoundation/coc-solidity coc-clangd coc-go coc-sumneko-lua coc-rust-analyzer<cr>"
            )

            function _G.show_docs()
                local cw = vim.fn.expand("<cword>")
                if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
                    vim.api.nvim_command("h " .. cw)
                elseif vim.api.nvim_eval("coc#rpc#ready()") then
                    vim.fn.CocActionAsync("doHover")
                else
                    vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
                end
            end

            vim.keymap.set("n", "K", "<CMD>lua _G.show_docs()<CR>")
        end,
    },
}
