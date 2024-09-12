return {
  "windwp/nvim-ts-autotag",
  config = function()
    require("nvim-ts-autotag").setup({
      enable = true,
      lazy = true,
      aliases = {
        ["astro"] = "html",
        ["eruby"] = "html",
        ["vue"] = "html",
        ["htmldjango"] = "html",
        ["markdown"] = "html",
        ["elixir"] = "html",
        ["heex"] = "html",
        ["php"] = "html",
        ["twig"] = "html",
        ["blade"] = "html",
        ["javascriptreact"] = "typescriptreact",
        ["javascript.jsx"] = "typescriptreact",
        ["typescript.tsx"] = "typescriptreact",
        ["javascript"] = "typescriptreact",
        ["typescript"] = "typescriptreact",
        ["rescript"] = "typescriptreact",
        ["handlebars"] = "glimmer",
        ["hbs"] = "glimmer",
        ["rust"] = "rust",
      },
    })
  end,
}
