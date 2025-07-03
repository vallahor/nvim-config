return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-bs>"] = function()
                vim.api.nvim_input("<c-s-w>")
              end,
              ["<c-k>"] = "move_selection_previous",
              ["<c-j>"] = "move_selection_next",
              ["<up>"] = "move_selection_previous",
              ["<down>"] = "move_selection_next",
              ["<esc>"] = actions.close,
              -- ["jk"] = actions.close,
              -- ["kj"] = actions.close,
              ["<c-w>"] = actions.delete_buffer, -- delete_buffer delete window too
            },
            n = {
              ["<esc>"] = actions.close,
              ["<c-space>"] = actions.close,
              ["jk"] = actions.close,
              ["kj"] = actions.close,
              -- ["fd"] = actions.close,
              -- ["df"] = actions.close,
              ["d"] = actions.delete_buffer,
            },
          },
          initial_mode = "insert",
          path_display = { "smart" },
          border = false,
          -- layout_strategy = "bottom_pane",
          -- layout_config = {
          --   height = 10,
          --   prompt_position = "bottom",
          -- },
          -- preview = false,
          file_ignore_patterns = {
            "node_modules",
            ".venv",
            ".git",
            "__pycache__",
            "_build",
            "_opam",
            "vendor",
            "deps",
            "public/build",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })

      vim.keymap.set("n", "<c-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
      vim.keymap.set("n", "<c-s-f>", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
      vim.keymap.set("n", "c-f", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
      -- vim.keymap.set("n", "<tab>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
      vim.keymap.set("n", "<c-m>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
      -- vim.keymap.set("n", "<tab>", "<cmd>lua require('telescope.builtin').buffers()<cr>")

      if vim.g.skeletyl then
        -- vim.keymap.set("n", "<tab>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
      else
        vim.keymap.set("n", "<c-space>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
      end
      -- vim.keymap.set("n", "<leader><leader>", "<cmd>lua require('telescope.builtin').buffers()<cr>")
    end,
  },
}
