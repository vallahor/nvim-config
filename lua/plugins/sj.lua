return {
  {
    "woosaaahh/sj.nvim",
    config = function()
      local sj = require("sj")
      sj.setup({
        separator = "",
      })

      vim.keymap.set({ "n", "v" }, ",", sj.prev_match)
      vim.keymap.set({ "n", "v" }, ";", sj.next_match)

      vim.keymap.set({ "n", "v", "o" }, "f", function()
        sj.run({
          auto_jump = true,
          forward_search = true,
          inclusive = true,
          max_pattern_length = 1,
          pattern_type = "lua_plain",
          search_scope = "current_line",
          use_overlay = false,
        })
      end)

      vim.keymap.set({ "n", "v", "o" }, "t", function()
        sj.run({
          auto_jump = true,
          forward_search = true,
          inclusive = false,
          max_pattern_length = 1,
          pattern_type = "lua_plain",
          search_scope = "current_line",
          use_overlay = false,
        })
      end)
    end,
  },
}
