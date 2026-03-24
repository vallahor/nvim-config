if true then
  return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "mini.nvim" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.g.neo_tree_remove_legacy_commands = 1

      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        local view = require("nvim-tree.view")

        api.map.on_attach.default(bufnr)

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
