vim.pack.add({ "https://github.com/chrisgrieser/nvim-spider", "https://github.com/chrisgrieser/nvim-various-textobjs" })

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

---@type any
local custom = {
  subwordMovement = false,
  customPatterns = { "[%w_%-]+", "[!\"#$%%&'()%*+,.%/:;<=>?@%[%]\\%^`{|}~]" },
}

vim.keymap.set({ "n", "o", "x" }, "w", function()
  spider.motion("w")
end)
vim.keymap.set({ "n", "o", "x" }, "e", function()
  spider.motion("e")
end)
vim.keymap.set({ "n", "o", "x" }, "b", function()
  spider.motion("b")
end)
vim.keymap.set({ "n", "o", "x" }, "q", function()
  spider.motion("ge")
end)

vim.keymap.set({ "n", "o", "x" }, "W", function()
  spider.motion("w", custom)
end)
vim.keymap.set({ "n", "o", "x" }, "E", function()
  spider.motion("e", custom)
end)
vim.keymap.set({ "n", "o", "x" }, "B", function()
  spider.motion("b", custom)
end)
vim.keymap.set({ "n", "o", "x" }, "Q", function()
  spider.motion("ge", custom)
end)

-- set "Q" to default "q"
vim.keymap.set("n", "R", "q")
-- vim.keymap.set({ "n", "x", "v" }, "q", "r")
--
local various_textobjs = require("various-textobjs")
---@diagnostic disable-next-line: param-type-mismatch, missing-fields
various_textobjs.setup({
  keymaps = {
    useDefaults = false,
  },
  notify = {
    whenObjectNotFound = false,
  },
})

vim.keymap.set({ "o", "x" }, "aw", function()
  various_textobjs.subword("outer")
end, { silent = true })

vim.keymap.set({ "o", "x" }, "iw", function()
  various_textobjs.subword("inner")
end, { silent = true })
