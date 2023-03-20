return {
    { "folke/lazy.nvim",       version = "*" },
    { "nvim-lua/plenary.nvim", lazy = true },
    { "tpope/vim-repeat",      event = "VeryLazy" },
    { "folke/which-key.nvim",  lazy = true },
    {
        dir = "../swap_buffer.lua",
        event = "VeryLazy",
        config = function()
            require("swap_buffer")
            vim.keymap.set("n", "<leader>h", "<cmd>lua Swap_left()<CR>")
            vim.keymap.set("n", "<leader>j", "<cmd>lua Swap_down()<CR>")
            vim.keymap.set("n", "<leader>k", "<cmd>lua Swap_up()<CR>")
            vim.keymap.set("n", "<leader>l", "<cmd>lua Swap_right()<CR>")
        end,
    },
    {
        dir = "../theme.lua",
        init = function()
            local theme = require("theme")
            theme.colorscheme()
        end,
    },
    { "Vimjas/vim-python-pep8-indent", event = "BufEnter *.py" },
    {
        "mattn/emmet-vim",
        event = "VeryLazy",
        config = function()
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = { "*.vue", "*.tsx", "*.jsx", "*.html" },
                command = ":EmmetInstall",
            })
            vim.keymap.set("i", "<c-y>", "<nop>")
            vim.keymap.set("i", "<c-y>", "<Plug>(emmet-expand-abbr)")
        end,
    },
}
