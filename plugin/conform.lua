vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")

local prettier = vim.fn.executable(vim.fn.stdpath("data") .. "/mason/bin/prettierd") == 1 and "prettierd" or "prettier"
local prettier_with_tailwind = { prettier, "rustywind" }

---@diagnostic disable-next-line: param-type-mismatch
conform.setup({
  formatters_by_ft = {
    json = { "prettierd", "prettier", stop_after_first = true },
    javascript = prettier_with_tailwind,
    javascriptreact = prettier_with_tailwind,
    typescript = prettier_with_tailwind,
    typescriptreact = prettier_with_tailwind,
    svelte = prettier_with_tailwind,
    lua = { "stylua" },
    python = { "ruff_format" },
    odin = { lsp_format = "fallback" },
    -- zig = { "zigfmt" },
    rust = { "rustfmt" },
    php = { "mago_format" },
    gdscript = { "gdscript-formatter" },
    -- gdscript = { "gdformat" },
    elixir = { "mix", "rustywind" },
    eelixir = { "mix", "rustywind" },
    heex = { "mix", "rustywind" },
  },
})

vim.keymap.set({ "n", "v" }, "<c-s>", function()
  conform.format({
    quiet = true,
    async = false,
  })

  vim.cmd.write({ bang = true, mods = { silent = true } })
end) -- save file and format
