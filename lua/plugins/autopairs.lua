return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        enable_check_bracket_line = true,
        enable_afterquote = false,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$%(%{]]=],
        map_cr = true,
        map_bs = false,
        map_c_h = false,
        map_c_w = false,
      })
    end,
  },
}
