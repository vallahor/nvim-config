return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      layout = {
        prompt_pos = "top",
      },
      matcher = {
        frecency = true,
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<CR>"] = { "confirm", mode = { "n", "i" } },
            ["<Up>"] = { "list_up", mode = { "n", "i" } },
            ["<Down>"] = { "list_down", mode = { "n", "i" } },
            ["<PageUp>"] = { "preview_scroll_up", mode = { "n", "i" } },
            ["<PageDown>"] = { "preview_scroll_down", mode = { "n", "i" } },
            ["<C-Up>"] = { "history_back", mode = { "n", "i" } },
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "SnacksPickerPreviewCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "SnacksPickerMatch", { link = "CurSearch" })
    vim.api.nvim_set_hl(0, "SnacksPickerPreviewMatch", { link = "CurSearch" })
    vim.api.nvim_set_hl(0, "SnacksPickerScrollbar", { link = "PmenuThumb" })
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "MiniIndentscopeSymbol" })
    vim.api.nvim_set_hl(0, "SnacksPicker", { link = "FloatNormal" })
    vim.api.nvim_set_hl(0, "SnacksPickerTitle", { link = "TabLineActive" })
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerPickerBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerListBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerFooter", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerBoxFooter", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerListFooter", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerInputFooter", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerPreviewFooter", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksPickerPreview", { link = "Normal" })
  end,
  keys = {
    {
      mode = "n",
      "0",
      function()
        Snacks.picker.files()
      end,
    },
    {
      mode = "n",
      "<tab>",
      function()
        Snacks.picker.buffers()
      end,
    },
    {
      mode = "n",
      "<C-f>",
      function()
        Snacks.picker.grep()
      end,
    },
    {
      mode = "n",
      "<C-S-f>",
      function()
        Snacks.picker.grep({ regex = false })
      end,
    },
    {
      mode = "n",
      "<C-0>",
      function()
        Snacks.picker.grep({ search = vim.fn.expand("<cword>") })
      end,
    },
  },
}
