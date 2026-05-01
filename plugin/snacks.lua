vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
  picker = {
    sources = {
      files = {
        cmd = "rg",
        args = {
          "--files",
          "--hidden",
          "--ignore",
          "--no-require-git",
          "--glob",
          "!node_modules",
          "--glob",
          "!.git",
          "--glob",
          "!.zig-cache",
          "--sortr=modified",
        },
      },
    },
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
    actions = {
      toggle_select = function(picker)
        picker.list:select()
      end,
      open_all = function(picker)
        local selected = picker:selected({ fallback = true })
        picker:close()
        for _, sel in ipairs(selected) do
          if sel.file then
            vim.cmd.edit({ vim.fn.fnameescape(sel.file), bang = true })
            if sel.pos then
              vim.api.nvim_win_set_cursor(0, { sel.pos[1], sel.pos[2] })
            end
          end
        end
      end,
    },
    icons = {
      ui = {
        selected = " ",
        unselected = " ",
      },
    },
    win = {
      input = {
        keys = {
          ["<tab>"] = { "toggle_select", mode = { "n", "i" } },
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          ["<CR>"] = { "open_all", mode = { "n", "i" } },
          ["<Up>"] = { "list_up", mode = { "n", "i" } },
          ["<Down>"] = { "list_down", mode = { "n", "i" } },
          ["<PageUp>"] = { "preview_scroll_up", mode = { "n", "i" } },
          ["<PageDown>"] = { "preview_scroll_down", mode = { "n", "i" } },
          ["<C-Up>"] = { "history_back", mode = { "n", "i" } },
        },
      },
    },
    list = {
      keys = {
        ["<CR>"] = "open_all",
      },
    },
  },
})

vim.keymap.set("n", "0", function()
  Snacks.picker.files()
end)
vim.keymap.set("n", "<tab>", function()
  Snacks.picker.buffers()
end)
vim.keymap.set("n", "<C-f>", function()
  Snacks.picker.grep()
end)
vim.keymap.set("n", "<C-S-f>", function()
  Snacks.picker.grep({ search = ".", regex = false, live = false })
end)
vim.keymap.set({ "n", "x" }, "<C-/>", function()
  Snacks.picker.grep_word()
end)

local hl = vim.api.nvim_set_hl
hl(0, "SnacksPickerListCursorLine", { link = "CursorLine" })
hl(0, "SnacksPickerPreviewCursorLine", { link = "CursorLine" })
hl(0, "SnacksPickerMatch", { link = "CurSearch" })
hl(0, "SnacksPickerPreviewMatch", { link = "CurSearch" })
hl(0, "SnacksPickerScrollbar", { link = "PmenuThumb" })
hl(0, "SnacksPickerDir", { link = "MiniIndentscopeSymbol" })
hl(0, "SnacksPicker", { link = "FloatNormal" })
hl(0, "SnacksPickerTitle", { link = "TabLineActive" })
hl(0, "SnacksPickerBorder", { link = "FloatBorder" })
hl(0, "SnacksPickerPickerBorder", { link = "FloatBorder" })
hl(0, "SnacksPickerListBorder", { link = "FloatBorder" })
hl(0, "SnacksPickerPreviewBorder", { link = "FloatBorder" })
hl(0, "SnacksPickerFooter", { link = "FloatBorder" })
hl(0, "SnacksPickerBoxFooter", { link = "FloatBorder" })
hl(0, "SnacksPickerListFooter", { link = "FloatBorder" })
hl(0, "SnacksPickerInputFooter", { link = "FloatBorder" })
hl(0, "SnacksPickerPreviewFooter", { link = "FloatBorder" })
hl(0, "SnacksPickerPreview", { link = "Normal" })
