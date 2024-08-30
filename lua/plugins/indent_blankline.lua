return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = {
        char = "¦",
        smart_indent_cap = true,
      },
      scope = {
        enabled = false,
      },
    },
    -- config = function()
    --   local ibl = require("ibl")
    -- end,
  },
}
