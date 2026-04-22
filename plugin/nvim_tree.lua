vim.pack.add({ "https://github.com/nvim-tree/nvim-tree.lua" })
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.neo_tree_remove_legacy_commands = 1

local api = require("nvim-tree.api")
local view = require("nvim-tree.view")

api.events.subscribe(api.events.Event.TreeOpen, function()
  local winnr = view.get_winnr() --[[@as integer?]]
  if winnr then
    vim.wo[winnr].statuscolumn = ""
    vim.api.nvim_set_option_value(
      "guicursor",
      "n:block-Cursor,i-ci-c:block-iCursor,v:block-vCursor,a:CursorHidden/lCursorHidden",
      {}
    )
  end
end)

api.events.subscribe(api.events.Event.FileRemoved, function(data)
  if not data then
    return
  end

  local bufnr = vim.fn.bufnr(data.fname)
  if bufnr == -1 then
    return
  end

  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  local buf_order = {}
  local idx = nil

  for _, b in ipairs(buffers) do
    if vim.bo[b.bufnr].filetype ~= "NvimTree" then
      buf_order[#buf_order + 1] = b.bufnr
      if b.bufnr == bufnr then
        idx = #buf_order
      end
    end
  end

  if not idx then
    return
  end

  local replacement = nil
  local last_buffer = false

  replacement = buf_order[idx + 1] or buf_order[idx - 1]

  if not replacement then
    replacement = vim.api.nvim_create_buf(true, false)
    last_buffer = true
  end

  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_set_buf(win, replacement)
  end

  if last_buffer then
    vim.schedule(function()
      api.tree.focus()
    end)
  end
end)

local default_size = 30

--- @param size integer?
local function resize(size)
  local winnr = view.get_winnr() --[[@as integer?]]
  if winnr then
    size = (size and vim.api.nvim_win_get_width(winnr) + size) or default_size

    if size < default_size then
      size = default_size
    end

    vim.api.nvim_win_set_width(winnr, size)
    vim.cmd.wincmd("=")
  end
end

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

  vim.keymap.set("n", "<c-)>", function()
    resize(10)
  end)
  vim.keymap.set("n", "<c-(>", function()
    resize(-10)
  end)
  vim.keymap.set("n", "<c-_>", function()
    resize()
  end)

  -- vim.keymap.set("n", "<c-f>", vim.cmd.NvimTreeFindFile, { buffer = true })
end

require("nvim-tree").setup({
  on_attach = on_attach,
  -- view = {
  --   side = "right",
  -- },
  actions = {
    remove_file = {
      close_window = false,
    },
  },
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
      web_devicons = {
        folder = { enable = true, color = true },
      },
      glyphs = {
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      },
      show = {
        git = false,
        folder_arrow = false,
      },
    },
  },
})

vim.keymap.set("n", "<c-e>", function()
  require("nvim-tree.api").tree.find_file({ update_root = false, open = true })
end)
vim.keymap.set("n", "<c-s-e>", function()
  require("nvim-tree.api").tree.find_file({ update_root = false, open = true, focus = true })
end)

vim.keymap.set("n", "<c-t>", vim.cmd.NvimTreeFocus)
vim.keymap.set("n", "<c-b>", vim.cmd.NvimTreeClose)
