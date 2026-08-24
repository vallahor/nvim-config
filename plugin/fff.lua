vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "fff" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("fff")
      end
      require("fff.download").download_or_build_binary()
    end
  end,
})

vim.pack.add({ "https://github.com/dmtrKovalenko/fff" })

require("fff").setup({
  lazy_sync = true,
  layout = {
    prompt_position = "top",
  },
  keymaps = {
    close = "<Esc>",
    select = "<CR>",
    move_up = "<Up>",
    move_down = "<Down>",
    preview_scroll_up = "<PageUp>",
    preview_scroll_down = "<PageDown>",
    cycle_previous_query = "<C-Up>",
    toggle_select = "<Tab>",
  },
  frecency = {
    enabled = false,
  },
  hl = {
    normal = "FloatNormal",
    border = "FloatBorder",
    title = "TabLineActive",
    prompt = "TabLineActive",
    cursor = "CursorLine",
    matched = "CurSearch",
    grep_match = "CurSearch",
    scrollbar = "PmenuThumb",
    directory_path = "MiniIndentscopeSymbol",
    selected = "MiniIndentscopeSymbol",
    selected_active = "CurSearch",
    file_info_section = "TabLineActive",
    file_info_separator = "FloatBorder",
    file_info_path = "MiniIndentscopeSymbol",
    winhl = {
      prompt = "Normal:FloatNormal,FloatBorder:FloatBorder,FloatTitle:TabLineActive",
      list = "Normal:FloatNormal,FloatBorder:FloatBorder,FloatTitle:TabLineActive",
      preview = "Normal:Normal,FloatBorder:FloatBorder,FloatTitle:TabLineActive",
      file_info = "Normal:Normal,FloatBorder:FloatBorder,FloatTitle:TabLineActive",
    },
  },
})

-- FFF does not currently expose a select-all action. Toggle every result that
-- is loaded for the current query and keep file selection order stable.
local function toggle_select_all()
  local picker_state = require("fff.picker_ui.picker_ui_state")
  local picker = require("fff.picker_ui.picker_ui")
  local state = picker_state.state
  local items = state.filtered_items

  if not state.active or #items == 0 then
    return
  end

  if state.mode == "grep" then
    local function key(item)
      return string.format("%s:%d:%d", item.relative_path, item.line_number or 1, item.col or 0)
    end

    local all_selected = vim.iter(items):all(function(item)
      return state.selected_items[key(item)] ~= nil
    end)

    for _, item in ipairs(items) do
      state.selected_items[key(item)] = all_selected and nil or item
    end
  else
    local all_selected = vim.iter(items):all(function(item)
      return state.selected_files[item.relative_path] ~= nil
    end)

    if all_selected then
      local visible = {}
      for _, item in ipairs(items) do
        visible[item.relative_path] = true
        state.selected_files[item.relative_path] = nil
      end
      state.selected_file_order = vim.tbl_filter(function(path)
        return not visible[path]
      end, state.selected_file_order)
    else
      for _, item in ipairs(items) do
        local path = item.relative_path
        if path and not state.selected_files[path] then
          state.selected_files[path] = true
          table.insert(state.selected_file_order, path)
        end
      end
    end
  end

  picker.render_list()
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fff_input", "fff_list", "fff_preview" },
  callback = function(ev)
    local modes = vim.bo[ev.buf].filetype == "fff_input" and { "i", "n" } or "n"
    vim.keymap.set(modes, "<C-a>", toggle_select_all, { buffer = ev.buf, silent = true })
  end,
})

local fff = require("fff")

vim.keymap.set("n", "0", fff.find_files)
vim.keymap.set("n", "<C-f>", fff.live_grep)
vim.keymap.set("n", "<C-S-f>", function()
  fff.live_grep({
    query = ".",
    grep = { modes = { "plain" } },
  })
end)
vim.keymap.set({ "n", "x" }, "<C-/>", fff.live_grep_under_cursor)
