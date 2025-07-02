return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        -- cs = { "csharpier" },
        elixir = { "mix" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        odin = { "odinfmt" },
        python = { "ruff_format" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        zig = { "zigfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
