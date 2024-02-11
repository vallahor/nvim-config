return {
  {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = function()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({
          disable_filetype = { "TelescopePrompt" , "vim" },
          ignored_next_char = [=[[
            %w%.%w%_%w%-%w%*%w%&%w%(%w%[%w%{%w%"%w%'%w%`%w%%%
          ]]=]
        })
      end
  },
}
