return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        json = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        python = { "ruff_format" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        rust = { "rustfmt" },
        -- gdscript = { "gdformat" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
        quiet = true,
        async = false,
      },
    })
  end,
}
