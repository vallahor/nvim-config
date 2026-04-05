return {
  "stevearc/conform.nvim",
  config = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    require("conform").setup({
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
      -- format_on_save = {
      --   -- timeout_ms = 500,
      --   lsp_format = "fallback",
      --   quiet = true,
      --   async = false,
      -- },
    })
  end,
}
