return {
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = false,
        subwordMovement = true,
        customPatterns = {
          patterns = {
            "%p",
          },
          overrideDefault = false,
        },
      })

      vim.keymap.set({ "n", "o", "x", "v" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
      vim.keymap.set({ "n", "o", "x", "v" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
      vim.keymap.set({ "n", "o", "x", "v" }, "b", "<cmd>lua require('spider').motion('b')<CR>")
      vim.keymap.set({ "n", "o", "x", "v" }, "r", "<cmd>lua require('spider').motion('ge')<CR>")

      vim.keymap.set(
        { "n", "o", "x", "v" },
        "W",
        "<cmd>lua require('spider').motion('w', { subwordMovement = false })<CR>"
      )
      vim.keymap.set(
        { "n", "o", "x", "v" },
        "E",
        "<cmd>lua require('spider').motion('e', { subwordMovement = false })<CR>"
      )
      vim.keymap.set(
        { "n", "o", "x", "v" },
        "B",
        "<cmd>lua require('spider').motion('b', { subwordMovement = false })<CR>"
      )
      vim.keymap.set(
        { "n", "o", "x", "v" },
        "R",
        "<cmd>lua require('spider').motion('ge', { subwordMovement = false })<CR>"
      )
      -- vim.keymap.set({ "n", "o", "x", "v" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>")
      -- vim.keymap.set({ "n", "o", "x", "v" }, "q", "<cmd>lua require('spider').motion('ge')<CR>")

      -- set "Q" to default "q"
      vim.keymap.set("n", "Q", "q")
      vim.keymap.set({ "n", "x", "v" }, "q", "r")
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "UIEnter",
    config = function()
      require("various-textobjs").setup({
        keymaps = {
          useDefaults = false,
        },
        notify = {
          whenObjectNotFound = false,
        },
      })
      vim.keymap.set({ "o", "x" }, "au", "aw")
      vim.keymap.set({ "o", "x" }, "iu", "iw")
      vim.keymap.set({ "o", "x" }, "aw", '<cmd>lua require("various-textobjs").subword("outer")<CR>', { silent = true })
      vim.keymap.set({ "o", "x" }, "iw", '<cmd>lua require("various-textobjs").subword("inner")<CR>', { silent = true })
    end,
  },
}
