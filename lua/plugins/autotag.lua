return {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-ts-autotag").setup({
      aliases = {
        ["blade"] = "html",
        ["php"] = "html",
      },
    })
  end,
}
