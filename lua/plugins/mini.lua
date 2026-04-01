return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Statusline

      -- https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/statusline.lua#L557
      local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
      local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

      local modes = setmetatable({
        ["n"] = { short = "N", hl = "MiniStatuslineModeNormal" },
        ["v"] = { short = "V", hl = "MiniStatuslineModeVisual" },
        ["V"] = { short = "V-L", hl = "MiniStatuslineModeVisual" },
        [CTRL_V] = { short = "V-B", hl = "MiniStatuslineModeVisual" },
        ["s"] = { short = "S", hl = "MiniStatuslineModeVisual" },
        ["S"] = { short = "S-L", hl = "MiniStatuslineModeVisual" },
        [CTRL_S] = { short = "S-B", hl = "MiniStatuslineModeVisual" },
        ["i"] = { short = "I", hl = "MiniStatuslineModeInsert" },
        ["R"] = { short = "R", hl = "MiniStatuslineModeReplace" },
        ["c"] = { short = "C", hl = "MiniStatuslineModeCommand" },
        ["r"] = { short = "P", hl = "MiniStatuslineModeOther" },
        ["!"] = { short = "Sh", hl = "MiniStatuslineModeOther" },
        ["t"] = { short = "T", hl = "MiniStatuslineModeOther" },
      }, {
        -- By default return 'Unknown' but this shouldn't be needed
        __index = function()
          return { short = "U", hl = "%#MiniStatuslineModeOther#" }
        end,
      })

      local MiniStatusline = require("mini.statusline")
      local location = "L%l/%L C%c"
      local get_filename = function()
        if vim.bo.buftype == "terminal" then
          return "%t"
        end
        return vim.fn.expand("%:.") .. "%m%r"
      end
      MiniStatusline.setup({
        use_icons = false,
        content = {
          active = function()
            local mode_info = modes[vim.api.nvim_get_mode().mode]
            local mode, mode_hl = mode_info.short, mode_info.hl

            local filename = get_filename()

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { strings = { "%S" } },
              { strings = { vim.bo.filetype } },
              { hl = mode_hl, strings = { location } },
            })
          end,
          inactive = function()
            local filename = get_filename()
            return MiniStatusline.combine_groups({
              { hl = "MiniStatuslineModeNormal", strings = { "-" } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { strings = { "%S" } },
              { strings = { vim.bo.filetype } },
              { strings = { location } },
            })
          end,
        },
      })

      -- Buf Remove
      local bufremove = require("mini.bufremove")
      bufremove.setup()

      vim.keymap.set("n", "<c-w>", function()
        _G.MiniBufremove.delete(0, false)
      end)
      vim.keymap.set("n", "<c-x>", function()
        _G.MiniBufremove.delete(0, true)
      end)

      -- closes the current window and buffer
      -- to close the current buffer and not the window use <c-w>
      vim.keymap.set("n", "<c-s-x>", "<cmd>bd<cr>") -- close current buffer and window -- not work with ghostty (combination in use)

      -- Cursor Word
      require("mini.cursorword").setup({
        delay = 0,
      })

      vim.api.nvim_set_hl(0, "MiniCursorword", {
        sp = "none",
        fg = "none",
        bg = "#2D2829",
      })
      vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {
        sp = "none",
        fg = "none",
        bg = "#2D2829",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "NvimTree", "neo-tree", "SidebarNvim" },
        callback = function()
          vim.b.ministatusline_disable = true
          vim.b.minicursorword_disable = true
        end,
      })

      local MiniIcons = require("mini.icons")
      MiniIcons.setup()
      MiniIcons.mock_nvim_web_devicons()

      vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = "#51a0cf" })
      vim.api.nvim_set_hl(0, "MiniIconsBlue", { fg = "#51a0cf" })
      vim.api.nvim_set_hl(0, "MiniIconsCyan", { fg = "#00bfff" })
      vim.api.nvim_set_hl(0, "MiniIconsGreen", { fg = "#8fbc8f" })
      vim.api.nvim_set_hl(0, "MiniIconsGrey", { fg = "#9e9e9e" })
      vim.api.nvim_set_hl(0, "MiniIconsOrange", { fg = "#d18b5f" })
      vim.api.nvim_set_hl(0, "MiniIconsPurple", { fg = "#9b59b6" })
      vim.api.nvim_set_hl(0, "MiniIconsRed", { fg = "#cc6666" })
      vim.api.nvim_set_hl(0, "MiniIconsWhite", { fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = "#f0c674" })

      -- Picker
      local pick = require("mini.pick")

      pick.setup({
        mappings = {
          caret_left = "<Left>",
          caret_right = "<Right>",

          choose = "<CR>",
          choose_in_split = "",
          choose_in_tabpage = "",
          choose_in_vsplit = "",
          choose_marked = "",

          delete_char = "<BS>",
          delete_char_right = "<Del>",
          delete_left = "",
          delete_word = "<C-bs>",

          mark = "",
          mark_all = "",

          -- move_down = "<down>",
          move_start = "<c-pageup>",
          -- move_up = "<up>",

          paste = "<c-v>",

          refine = "",
          refine_marked = "",

          scroll_down = "<PageDown>",
          scroll_left = "<c-left>",
          scroll_right = "<c-right>",
          scroll_up = "<PageUp>",

          stop = "<Esc>",

          toggle_info = "",
          toggle_preview = "<Tab>",
        },
      })

      local wipeout_cur = function()
        local picker_matches = pick.get_picker_matches()
        if not picker_matches then
          return
        end

        local current = picker_matches.current
        if not current or not current.bufnr then
          return
        end

        bufremove.delete(current.bufnr, false)

        -- https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/pick.lua#L1497
        local buffers = vim.api.nvim_exec2("buffers" .. "", { output = true })
        local cur_buf_id = vim.api.nvim_get_current_buf()
        local items = {}
        for _, l in ipairs(vim.split(buffers.output, "\n")) do
          local buf_str, name = l:match("^%s*%d+"), l:match('"(.*)"')
          local buf_id = tonumber(buf_str)
          local item = { text = name, bufnr = buf_id }
          if buf_id ~= cur_buf_id then
            table.insert(items, item)
          end
        end
        pick.set_picker_items(items)
      end
      local buffer_mappings = { wipeout = { char = "<c-x>", func = wipeout_cur } }
      vim.keymap.set("n", "<tab>", function()
        pick.builtin.buffers({ include_current = true }, { mappings = buffer_mappings })
      end)
    end,
  },
}
