return {
  {
    "echasnovski/mini.nvim",
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    },
    version = false,
    config = function()
      -- Comment
      require("mini.comment").setup({
        options = {
          ignore_blank_line = true,
          custom_commentstring = function()
            return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
          end,
        },
        hooks = {
          pre = function()
            require("ts_context_commentstring.internal").update_commentstring({})
          end,
        },
        mappings = {
          comment = "gc",
          comment_line = "gc",
          comment_visual = "gc",
        },
      })

      vim.cmd([[
          autocmd FileType gdscript setlocal commentstring=#\ %s
          autocmd FileType c setlocal commentstring=//\ %s
          autocmd FileType cs setlocal commentstring=//\ %s
          autocmd FileType cpp setlocal commentstring=//\ %s
          autocmd FileType odin setlocal commentstring=//\ %s
      ]])

      if not vim.g.skeletyl then
        require("mini.move").setup({
          mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = "",
            right = "",
            down = "J",
            up = "K",

            -- Move current line in Normal mode
            line_left = "",
            line_right = "",
            line_down = "",
            line_up = "",
          },
        })
      else
        require("mini.move").setup({
          mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = "",
            right = "",
            down = "<down>",
            up = "<up>",

            -- Move current line in Normal mode
            line_left = "",
            line_right = "",
            line_down = "",
            line_up = "",
          },
        })
      end

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
      local location = " L%l/%L C%c "
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
            local mode_info = modes[vim.fn.mode()]
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
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { strings = { location } },
            })
          end,
        },
      })

      -- Buf Remove
      require("mini.bufremove").setup()

      if vim.g.skeletyl then
        vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>")
        vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")
        vim.keymap.set("n", "<c-x>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")
      else
        vim.keymap.set("n", "<c-w>", "<cmd>lua MiniBufremove.delete(0, false)<CR>")
        vim.keymap.set("n", "<a-w>", "<cmd>lua MiniBufremove.delete(0, true)<CR>")
      end

      -- Cursor Word
      require("mini.cursorword").setup({
        delay = 0,
      })

      vim.api.nvim_create_autocmd(
        "FileType",
        { pattern = { "NvimTree" }, command = "lua vim.b.minicursorword_disable=true" }
      )

      local mini_icons = require("mini.icons")
      mini_icons.setup()
      mini_icons.mock_nvim_web_devicons()

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

          move_down = "<down>",
          move_start = "<pageup>",
          move_up = "<up>",

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

      pick.registry.files_rg = function()
        local command = {
          "rg",
          "--files",
          "--hidden",
          "--ignore",
          "--no-require-git",
          "--glob",
          "!.git",
          "--sortr=modified",
        }
        local show_with_icons = function(buf_id, items, query)
          return pick.default_show(buf_id, items, query, { show_icons = true })
        end
        local source = { name = "Files rg", show = show_with_icons }
        return pick.builtin.cli({ command = command }, { source = source })
      end

      -- vim.keymap.set("n", "0", "<cmd>Pick files<CR>")
      vim.keymap.set("n", "0", "<cmd>Pick files_rg<CR>")
      vim.keymap.set("n", "<c-p>", "<cmd>Pick files_rg<CR>")
      vim.keymap.set("n", "<s-tab>", "<cmd>Pick grep<CR>")

      local bufremove = require("mini.bufremove")
      local wipeout_cur = function()
        local current = pick.get_picker_matches().current
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
