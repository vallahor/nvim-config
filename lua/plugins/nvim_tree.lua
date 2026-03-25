if true then
  return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "mini.nvim" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.g.neo_tree_remove_legacy_commands = 1

      local api = require("nvim-tree.api")
      local view = require("nvim-tree.view")

      local cursor_hl = vim.api.nvim_get_hl(0, { name = "Cursor", link = false })
      vim.api.nvim_set_hl(0, "NvimTreeCursor", { fg = "#222022", bg = "#A98D92" })

      -- https://coolors.co/gradient-palette/291c28-1e141d?number=7
      local cursor_line_active = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })
      local cursor_line_inactive = { fg = "#a1495c", bg = "#20151F" }
      local cursor_linenr_active = vim.api.nvim_get_hl(0, { name = "CursorLineNr", link = false })
      vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = cursor_line_inactive.bg })

      api.events.subscribe(api.events.Event.TreeOpen, function()
        local winnr = view.get_winnr()
        if winnr then
          vim.wo[winnr].statuscolumn = ""
          vim.wo[winnr].winhighlight = "CursorLine:NvimTreeCursorLine"
        end
      end)

      local cursor_hidden = false
      local ignore_file_types = { NvimTree = true }
      vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "CmdlineLeave" }, {
        callback = function()
          if ignore_file_types[vim.bo.filetype] then
            cursor_hidden = true
            vim.api.nvim_set_hl(0, "NvimTreeCursor", { blend = 100, fg = cursor_hl.fg, bg = cursor_hl.bg })
            vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = cursor_line_active.bg })
            vim.api.nvim_set_hl(0, "CursorLine", { bg = cursor_line_inactive.bg })
            vim.api.nvim_set_hl(0, "CursorLineNr", { fg = cursor_linenr_active.fg, bg = cursor_line_inactive.bg })
            vim.opt_local.guicursor:append("a:NvimTreeCursor/lNvimTreeCursor")
          elseif cursor_hidden then
            cursor_hidden = false
            vim.api.nvim_set_hl(0, "NvimTreeCursor", { blend = 0, fg = cursor_hl.fg, bg = cursor_hl.bg })
            vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = cursor_line_inactive.bg })
            vim.api.nvim_set_hl(0, "CursorLine", { bg = cursor_line_active.bg })
            vim.api.nvim_set_hl(0, "CursorLineNr", { fg = cursor_linenr_active.fg, bg = cursor_linenr_active.bg })
            vim.opt_local.guicursor:remove("a:NvimTreeCursor/lNvimTreeCursor")
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
        callback = function()
          if cursor_hidden then
            cursor_hidden = false
            vim.opt_local.guicursor:remove("a:NvimTreeCursor/lNvimTreeCursor")
          end
        end,
      })

      local function on_attach(bufnr)
        api.map.on_attach.default(bufnr)

        vim.keymap.set("n", "l", function()
          local node = api.tree.get_node_under_cursor()
          if node.type == "directory" then
            api.node.open.edit()
          end
        end, { buffer = bufnr, noremap = true, silent = true, nowait = true })

        vim.keymap.set(
          "n",
          "h",
          api.node.navigate.parent_close,
          { buffer = bufnr, noremap = true, silent = true, nowait = true }
        )

        vim.keymap.set("n", "<C-t>", function()
          vim.cmd.wincmd("p")
        end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
        vim.keymap.set("n", "t", function()
          vim.cmd.wincmd("p")
        end, { buffer = bufnr, noremap = true, silent = true, nowait = true })

        local function resize_tree(delta)
          local winnr = view.get_winnr()
          if winnr then
            api.tree.resize({ width = vim.api.nvim_win_get_width(winnr) + delta })
          end
        end

        vim.keymap.set("n", "<c-.>", function()
          resize_tree(5)
        end)
        vim.keymap.set("n", "<c-,>", function()
          resize_tree(-5)
        end)
        vim.keymap.set("n", "<c-s-t>", function()
          api.tree.resize()
        end)

        vim.keymap.set("n", "<c-/>", function()
          require("nvim-tree.api").tree.find_file({ update_root = false })
        end)
        vim.keymap.set("n", "<c-?>", function()
          require("nvim-tree.api").tree.find_file({ update_root = false, open = true, focus = true })
        end)

        -- vim.keymap.set("n", "<c-f>", "<cmd>NvimTreeFindFile<cr>", { buffer = true })
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        update_focused_file = {
          enable = false,
        },
        git = {
          enable = false,
          ignore = false,
        },
        filters = {
          dotfiles = false,
          custom = { ".venv", "node_modules", "__pycache__" },
        },
        renderer = {
          indent_markers = {
            enable = true,
          },
          icons = {
            show = {
              git = false,
              folder_arrow = false,
            },
          },
        },
      })

      vim.keymap.set("n", "<c-t>", "<cmd>NvimTreeFocus<cr>")
      vim.keymap.set("n", "<c-b>", "<cmd>NvimTreeClose<cr>")
    end,
  }
else
  return {
    "stevearc/oil.nvim",
    lazy = false,
    enabled = true,
    opts = {
      columns = {
        "size",
        "mtime",
      },
      buf_options = { buflisted = false, bufhidden = "hide" },
      delete_to_trash = true,
      lsp_file_methods = { enabled = false },
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["<C-s>"] = false,
        -- ["-"] = false,
        ["-"] = { "actions.parent", mode = "n" },
        ["+"] = "actions.select",
        [")"] = "actions.select",
        ["("] = { "actions.parent", mode = "n" },
        -- ["<c-.>"] = "actions.select",
        -- ["<c-,>"] = { "actions.parent", mode = "n" },
        ["q"] = "actions.close",
        -- ["<esc>"] = "actions.close",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(_, _)
          return false
        end,
        sort = {
          { "mtime", "desc" },
        },
      },
    },
    keys = {
      -- { "-", "<cmd>lua require('oil').toggle_float()<cr>", desc = "Open file browser" },
      { "<c-t>", "<cmd>Oil<cr>", desc = "Open file browser" },
    },
  }
end
