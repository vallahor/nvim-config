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

local api = vim.api
local mc = require("user.multicursor")

local function move_every_cursor(spider_motion, opts)
  -- A replayed Lua mapping has no resolved motion keys. Move each tracking
  -- extmark explicitly, while Spider calculates a context-specific target at
  -- every cursor.
  if api.nvim__mcursor_cascading() then
    return
  end

  local marks = api.nvim_buf_get_extmarks(0, mc.ns, 0, -1, {})
  local primary = api.nvim_win_get_cursor(0)

  for _, mark in ipairs(marks) do
    local pos = api.nvim_buf_get_extmark_by_id(0, mc.ns, mark[1], {})
    if #pos > 0 then
      api.nvim_win_set_cursor(0, { pos[1] + 1, pos[2] })
      spider.motion(spider_motion, opts)
      local target = api.nvim_win_get_cursor(0)
      mc.set_cursor(mark[1], target[1] - 1, target[2])
    end
  end

  api.nvim_win_set_cursor(0, primary)
  spider.motion(spider_motion, opts)
end

-- Search motions are native, context-sensitive CmdAtoms, so Neovim resolves
-- them independently for every Visual multicursor. API cursor moves from
-- spider.motion() are not replayable, while a relative h/l fallback gives all
-- selections the primary cursor's distance.
local subword_start =
  [=[\%(\%(^\|[^[:alpha:]]\)\zs\l\|\%(^\|[^\u]\)\zs\u\|\u\ze\l\|\%(^\|\D\)\zs\d\|\%(^\|[^[:punct:]]\)\zs[[:punct:]]\)]=]
local subword_end = [=[\%(\l\ze\L\|\u\ze\U\|\d\ze\D\|[[:punct:]]\ze[^[:punct:]]\|.$\)]=]
local whole_start = [=[\%(\%(^\|[^[:alnum:]_-]\)\zs[[:alnum:]_-]\|[[:punct:]]\)]=]
local whole_end = [=[\%([[:alnum:]_-]\ze[^[:alnum:]_-]\|[[:punct:]]\|.$\)]=]

local function visual_spider_motion(spider_motion, opts)
  local backwards = spider_motion == "b" or spider_motion == "ge"
  local ends_word = spider_motion == "e" or spider_motion == "ge"
  local whole_word = opts == custom
  local pattern = ends_word and (whole_word and whole_end or subword_end)
    or (whole_word and whole_start or subword_start)
  local previous_search = vim.fn.getreg("/")
  local previous_hlsearch = vim.v.hlsearch == 1

  mc.feed((backwards and "?" or "/") .. pattern .. "<CR>")

  -- Do not expose the implementation search as the user's last search.
  vim.schedule(function()
    if vim.fn.getreg("/") == pattern then
      vim.fn.histdel("search", -1)
      vim.fn.setreg("/", previous_search)
      vim.opt.hlsearch = previous_hlsearch
    end
  end)
end

local function map_motion(lhs, spider_motion, native_motion, opts)
  vim.keymap.set({ "n", "o", "x" }, lhs, function()
    if mc.has() then
      local mode = api.nvim_get_mode().mode
      if mode == "n" then
        move_every_cursor(spider_motion, opts)
      elseif mode == "v" or mode == "V" or mode == "\22" then
        visual_spider_motion(spider_motion, opts)
      else
        mc.feed(native_motion)
      end
    else
      spider.motion(spider_motion, opts)
    end
  end)
end

map_motion("w", "w", "w")
map_motion("e", "e", "e")
map_motion("b", "b", "b")
map_motion("q", "ge", "ge")

map_motion("W", "w", "W", custom)
map_motion("E", "e", "E", custom)
map_motion("B", "b", "B", custom)
map_motion("Q", "ge", "gE", custom)

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
