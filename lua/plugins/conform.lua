return {
  "stevearc/conform.nvim",
  config = function()
    -- bun install -g @fsouza/prettierd
    -- cargo install stylua
    -- pip install ruff
    -- dotnet tool install csharpier -g
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        odin = { "odinfmt", lsp_format = "fallback" },
        zig = { "zigfmt", lsp_format = "fallback" },
        elixir = { "mix", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
