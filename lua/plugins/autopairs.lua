return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        disable_filetype = { "TelescopePrompt", "vim" },
        ignored_next_char = [=[[
            %w%.%w%_%w%-%w%*%w%&%w%(%w%[%w%{%w%"%w%'%w%`%w%%%
          ]]=],
      })
      autopairs.add_rules(require("nvim-autopairs.rules.endwise-elixir"))

      -- local npairs = require("nvim-autopairs")
      -- local Rule = require("nvim-autopairs.rule")
      -- local cond = require("nvim-autopairs.conds")

      -- npairs.add_rules({
      --   Rule("<%% ", " %>", { "elixir", "heex", "eelixir" }):with_move(cond.none()):use_regex(true),
      --   Rule("<%%= ", " %>", { "elixir", "heex", "eelixir" }):with_move(cond.none()):use_regex(true),
      -- })
    end,
  },
}
