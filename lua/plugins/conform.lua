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
        svelte = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        python = { "ruff_format" },
        php = { "mago_format" },
        -- cs = { "csharpier" },
        zig = { "zigfmt" },
        rust = { "rustfmt" },
        odin = { lsp_format = "fallback" },
        -- go = { "goimports", "golines", "gofmt", lsp_format = "fallback" },
        -- elixir = { "mix", lsp_format = "fallback" },
        elixir = { lsp_format = "fallback" },
        gdscript = { "gdformat" },
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
