return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      filewatching = "roslyn",
    },
  },
  {
    "apyra/nvim-unity-sync",
    lazy = false,
    config = function()
      require("unity.plugin").setup()
    end,
  },
}
