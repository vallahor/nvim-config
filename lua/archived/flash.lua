return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "m",
      mode = { "n", "x", "o", "v" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
  },
}
