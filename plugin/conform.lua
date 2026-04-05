vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { load = true })

local conform = require("conform")
---@diagnostic disable-next-line: param-type-mismatch
conform.setup({
  formatters_by_ft = {
    json = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    svelte = { "prettier", stop_after_first = true },
    lua = { "stylua" },
    python = { "ruff_format" },
    zig = { "zigfmt" },
    rust = { "rustfmt" },
    odin = { lsp_format = "fallback" },
    -- go = { "goimports", "golines", "gofmt", lsp_format = "fallback" },
  },
  formatters = {
    prettier = {
      prepend_args = function(_, ctx)
        if vim.bo[ctx.buf].filetype == "svelte" then
          return {
            "--plugin",
            vim.fn.expand("~/.bun/install/global/node_modules/prettier-plugin-svelte/plugin.js"),
            "--parser",
            "svelte",
          }
        end
        return {}
      end,
    },
  },
})

vim.keymap.set({ "n", "v" }, "<c-s>", function()
  conform.format({
    quiet = true,
    async = false,
  })
  vim.cmd.write({ bang = true, mods = { silent = true } })
end) -- save file
