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
      local MiniStatusline = require("mini.statusline")
      local location = " L%l/%L C%c "
      MiniStatusline.setup({
        use_icons = false,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })

            local filename = MiniStatusline.section_filename({ trunc_width = 200 })

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              -- { hl = mode_hl, strings = { mode:sub(1, 1) } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { strings = { "%S" } },
              { strings = { vim.bo.filetype } },
              { hl = mode_hl, strings = { location } },
            })
          end,
          inactive = function()
            local filename = MiniStatusline.section_filename({ trunc_width = 200 })

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

      local MiniIcons = require("mini.icons")
      MiniIcons.setup()
      MiniIcons.mock_nvim_web_devicons()

      require("mini.notify").setup()

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
        local command = { "rg", "--files", "--no-require-git", "--glob", "!.git/" }
        local show_with_icons = function(buf_id, items, query)
          return pick.default_show(buf_id, items, query, { show_icons = true })
        end
        local source = { name = "Files rg", show = show_with_icons }
        return pick.builtin.cli({ command = command }, { source = source })
      end

      -- vim.keymap.set("n", "0", "<cmd>Pick files<CR>")
      vim.keymap.set("n", "0", "<cmd>Pick files_rg<CR>")
      vim.keymap.set("n", "<c-tab>", "<cmd>Pick grep<CR>")

      local bufremove = require("mini.bufremove")
      local wipeout_cur = function()
        local current = pick.get_picker_matches().current
        if not current or not current.bufnr then
          return
        end

        bufremove.delete(current.bufnr, false)

        local buffers = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
            table.insert(buffers, {
              text = vim.api.nvim_buf_get_name(buf),
              bufnr = buf,
            })
          end
        end
        pick.set_picker_items(buffers)
      end
      local buffer_mappings = { wipeout = { char = "<c-x>", func = wipeout_cur } }
      vim.keymap.set("n", "<tab>", function()
        pick.builtin.buffers({ include_current = true }, { mappings = buffer_mappings })
      end)
    end,
  },
}
