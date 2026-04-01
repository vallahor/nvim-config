return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "mini.nvim" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.neo_tree_remove_legacy_commands = 1

    local api = require("nvim-tree.api")
    local view = require("nvim-tree.view")

    api.events.subscribe(api.events.Event.TreeOpen, function()
      local winnr = view.get_winnr() --[[@as integer?]]
      if winnr then
        vim.wo[winnr].statuscolumn = ""
      end
      vim.opt_local.guicursor = "a:CursorHidden/lCursorHidden"
    end)

    local function on_attach(bufnr)
      api.map.on_attach.default(bufnr)

      vim.keymap.set("n", "l", function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "directory" then
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

      vim.keymap.set("n", "<c-.>", function()
        view.resize("+5")
      end)
      vim.keymap.set("n", "<c-,>", function()
        view.resize("-5")
      end)
      vim.keymap.set("n", "<c-s-t>", function()
        view.resize(30)
      end)

      vim.keymap.set("n", "<c-e>", function()
        require("nvim-tree.api").tree.find_file({ update_root = false })
      end)
      vim.keymap.set("n", "<c-s-e>", function()
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
