return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  config = function()
    local fff = require("fff")
    fff.setup({
      preview = {
        enabled = false,
      },
      debug = {
        enabled = false,
        show_scores = false,
      },
      prompt = " ",
      layout = {
        width = 0.4,
        height = 0.4,
        prompt_position = "top",
      },
      frecency = {
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
    })

    vim.keymap.set("n", "0", fff.find_files)
    vim.keymap.set("n", "<c-f>", fff.live_grep)
    vim.keymap.set("n", "<c-s-f>", function()
      fff.live_grep({ grep = { modes = { "fuzzy", "plain" } } })
    end)
    vim.keymap.set("n", "<c-/>", function()
      fff.live_grep({ query = vim.fn.expand("<cword>") })
    end)
    vim.keymap.set("v", "<c-/>", function()
      vim.cmd('normal! "sy')
      fff.live_grep({ query = vim.fn.getreg("s") })
    end)
  end,
}
