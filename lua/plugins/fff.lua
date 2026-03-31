return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  opts = {
    preview = {
      enabled = false,
    },
    debug = {
      enabled = false,
      show_scores = false,
    },
    prompt = "> ",
    layout = {
      width = 0.4,
      height = 0.4,
      prompt_position = "top",
    },
    grep = {
      modes = { "plain", "fuzzy" },
    },
    frequency = {
      enabled = true,
    },
    history = {
      enabled = false,
    },
    logging = {
      enabled = false,
    },
    keymaps = {
      close = "<Esc>",
      select = "<CR>",
      move_up = "<Up>",
      move_down = "<Down>",
      preview_scroll_up = "<PageUp>",
      preview_scroll_down = "<PageDown>",
      cycle_previous_query = "<C-Up>",
      cycle_next_query = "<C-Down>",
    },
    hl = {
      normal = "FloatNormal",
      matched = "CurSearch",
      grep_match = "CurSearch",
      cursor = "CursorLine",
      scrollbar = "PmenuThumb",
      directory_path = "MiniIndentscopeSymbol",
      title = "TabLineActive",
      prompt = "TabLineActive",
    },
  },
  keys = {
    {
      "0",
      function()
        require("fff").find_files()
      end,
    },
    {
      "<c-f>",
      function()
        require("fff").live_grep()
      end,
    },
    {
      "<c-s-f>",
      function()
        require("fff").live_grep({
          grep = {
            modes = { "fuzzy", "plain" },
          },
        })
      end,
    },
    {
      "<c-0>",
      function()
        require("fff").live_grep({ query = vim.fn.expand("<cword>") })
      end,
    },
  },
}
