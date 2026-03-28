return {
    "chrisgrieser/nvim-spider",
    config = function()
      local spider = require("spider")
      spider.setup({
        skipInsignificantPunctuation = false,
        consistentOperatorPending = false,
        subwordMovement = true,
        customPatterns = {
          patterns = {
            "%p",
          },
          overrideDefault = false,
        },
      })

      local custom = {
        subwordMovement = false,
        customPatterns = { "[%w_%-]+", "[!\"#$%%&'()%*+,.%/:;<=>?@%[%]\\%^`{|}~]" },
      } --[[@as any]]

      vim.keymap.set({ "n", "o", "x", "v" }, "w", function()
        spider.motion("w")
      end)
      vim.keymap.set({ "n", "o", "x", "v" }, "e", function()
        spider.motion("e")
      end)
      vim.keymap.set({ "n", "o", "x", "v" }, "b", function()
        spider.motion("b")
      end)
      vim.keymap.set({ "n", "o", "x", "v" }, "q", function()
        spider.motion("ge")
      end)

      vim.keymap.set({ "n", "o", "x", "v" }, "W", function()
        spider.motion("w", custom)
      end)
      vim.keymap.set({ "n", "o", "x", "v" }, "E", function()
        spider.motion("e", custom)
      end)
      vim.keymap.set({ "n", "o", "x", "v" }, "B", function()
        spider.motion("b", custom)
      end)
      vim.keymap.set({ "n", "o", "x", "v" }, "Q", function()
        spider.motion("ge", custom)
      end)

      -- set "Q" to default "q"
      vim.keymap.set("n", "R", "q")
      -- vim.keymap.set({ "n", "x", "v" }, "q", "r")
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
