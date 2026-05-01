vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")
---@diagnostic disable-next-line: param-type-mismatch
conform.setup({
  formatters_by_ft = {
    json = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    lua = { "stylua" },
    python = { "ruff_format" },
    zig = { "zigfmt" },
    rust = { "rustfmt" },
  },
})

vim.keymap.set({ "n", "v" }, "<c-s>", function()
  conform.format({
    quiet = true,
    async = false,
  })
  vim.cmd.write({ bang = true, mods = { silent = true } })
end) -- save file and format
