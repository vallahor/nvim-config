return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.neo_tree_remove_legacy_commands = 1

    local function on_attach(bufnr)
      local api = require("nvim-tree.api")

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "<C-t>", function()
        vim.cmd.wincmd("p")
      end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
      vim.keymap.set("n", "t", function()
        vim.cmd.wincmd("p")
      end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
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

    vim.keymap.set("n", "<c-f>", "<cmd>NvimTreeFindFile<cr>")
  end,
}
