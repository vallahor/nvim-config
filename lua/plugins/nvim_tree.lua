return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "mini.nvim",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.neo_tree_remove_legacy_commands = 1

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      -- your removals and mappings go here
      -- vim.keymap.set("n", "<C-t>", api.tree.close, opts("Close"))
      vim.keymap.set("n", "<C-t>", function()
        vim.cmd.wincmd("p")
      end, opts("Toggle Tree Focus"))
      vim.keymap.set("n", "t", function()
        vim.cmd.wincmd("p")
      end, opts("Toggle Tree Focus"))
    end

    require("nvim-tree").setup({
      on_attach = my_on_attach,
      update_focused_file = {
        enable = true,
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

    vim.keymap.set("n", "<c-t>", "<cmd>NvimTreeFocus<cr>", { silent = true })
    vim.keymap.set("n", "<c-b>", "<cmd>NvimTreeClose<cr>", { silent = true })
  end,
}
