return {
  {
    "jake-stewart/multicursor.nvim",
    -- branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Disable and enable cursors.
      vim.keymap.set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Add a cursor for all matches of cursor word/selection in the document.
      vim.keymap.set({ "n", "x" }, "<c-u>", mc.matchAllAddCursors)
      -- bring back cursors if you accidentally clear them
      vim.keymap.set("n", "Z", mc.restoreCursors)
      vim.keymap.set("n", "<c-z>", mc.restoreCursors)

      if vim.g.normal_kbd then
        -- Add or skip cursor above/below the main cursor.
        vim.keymap.set({ "n", "x" }, "<a-k>", function()
          mc.lineAddCursor(-1)
        end)
        vim.keymap.set({ "n", "x" }, "<a-j>", function()
          mc.lineAddCursor(1)
        end)
        vim.keymap.set({ "n", "x" }, "<a-s-k>", function()
          mc.lineSkipCursor(-1)
        end)
        vim.keymap.set({ "n", "x" }, "<a-s-j>", function()
          mc.lineSkipCursor(1)
        end)

        -- Add or skip adding a new cursor by matching word/selection
        vim.keymap.set({ "n", "x" }, "<a-l>", function()
          mc.matchAddCursor(1)
        end)
        vim.keymap.set({ "n", "x" }, "<a-s-l>", function()
          mc.matchSkipCursor(1)
        end)
        vim.keymap.set({ "n", "x" }, "<a-h>", function()
          mc.matchAddCursor(-1)
        end)
        vim.keymap.set({ "n", "x" }, "<a-s-h>", function()
          mc.matchSkipCursor(-1)
        end)

        -- Align cursor columns.
        vim.keymap.set("n", "<a-a>", mc.alignCursors)
      else
        -- Add or skip cursor above/below the main cursor.
        vim.keymap.set({ "n", "x" }, "<c-k>", function()
          mc.lineAddCursor(-1)
        end)
        vim.keymap.set({ "n", "x" }, "<c-j>", function()
          mc.lineAddCursor(1)
        end)
        vim.keymap.set({ "n", "x" }, "<c-s-k>", function()
          mc.lineSkipCursor(-1)
        end)
        vim.keymap.set({ "n", "x" }, "<c-s-j>", function()
          mc.lineSkipCursor(1)
        end)

        -- Add or skip adding a new cursor by matching word/selection
        vim.keymap.set({ "n", "x" }, "<c-l>", function()
          mc.matchAddCursor(1)
        end)
        vim.keymap.set({ "n", "x" }, "<c-s-l>", function()
          mc.matchSkipCursor(1)
        end)
        vim.keymap.set({ "n", "x" }, "<c-h>", function()
          mc.matchAddCursor(-1)
        end)
        vim.keymap.set({ "n", "x" }, "<c-s-h>", function()
          mc.matchSkipCursor(-1)
        end)
        -- Align cursor columns.
        vim.keymap.set("n", "<c-s-a>", mc.alignCursors)
      end

      -- Split visual selections by regex.
      vim.keymap.set("x", "<c-s-s>", mc.splitCursors)

      -- match new cursors within visual selections by regex.
      vim.keymap.set("x", "<c-s-m>", mc.matchCursors)

      -- Add and remove cursors with control + left click.
      vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
      vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
      vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Append/insert for each line of visual selections.
      -- Similar to block selection insertion.
      vim.keymap.set("v", "I", mc.insertVisual)
      vim.keymap.set("v", "A", mc.appendVisual)

      vim.keymap.set({ "n", "x" }, "gA", mc.sequenceIncrement)
      vim.keymap.set({ "n", "x" }, "gX", mc.sequenceDecrement)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        if vim.g.normal_kbd then
          -- -- Select a different cursor as the main one.
          layerSet({ "n", "x" }, "<a-p>", mc.prevCursor)
          layerSet({ "n", "x" }, "<a-n>", mc.nextCursor)
        else
          -- -- Select a different cursor as the main one.
          layerSet({ "n", "x" }, "<a-left>", mc.prevCursor)
          layerSet({ "n", "x" }, "<a-right>", mc.nextCursor)
        end

        -- -- Delete the main cursor.
        -- layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        layerSet("n", "<esc>", function()
          mc.clearCursors()
        end)
        layerSet("n", "<c-m>", function()
          mc.enableCursors()
        end)
      end)

      vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
      vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
      -- vim.api.nvim_set_hl(0, "MultiCursorVisual", { reverse = true })
      -- vim.api.nvim_set_hl(0, "MultiCursorVisual", { fg = "#2d1524", bg = "#A98D92", reverse = true })
      vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
      vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { link = "Search" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { reverse = true })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })

      -- mc.onSafeState(function()
      --   local ft = vim.bo.filetype
      --   if ft == "NvimTree" or ft == "neo-tree" or ft == "SidebarNvim" then
      --     return
      --   end
      -- end)

      local mc_ns = nil
      local mc_match_ids = {}

      mc.onSafeState(function()
        local ft = vim.bo.filetype
        if ft == "NvimTree" or ft == "neo-tree" or ft == "SidebarNvim" then
          return
        end

        for _, id in ipairs(mc_match_ids) do
          pcall(vim.fn.matchdelete, id)
        end
        mc_match_ids = {}

        if not mc.hasCursors() then
          return
        end

        if not mc_ns then
          mc_ns = vim.api.nvim_get_namespaces()["multicursor-nvim"]
          if not mc_ns then
            return
          end
        end

        local marks = vim.api.nvim_buf_get_extmarks(0, mc_ns, 0, -1, { details = true })
        for _, m in ipairs(marks) do
          local hl = m[4].hl_group
          if hl and hl:match("MultiCursor") then
            local row = m[2] + 1
            local col = m[3] + 1
            local length = m[4].end_col and (m[4].end_col - m[3]) or 1
            local id = vim.fn.matchaddpos(hl, { { row, col, length } }, 999)
            mc_match_ids[#mc_match_ids + 1] = id
          end
        end
      end)
    end,
  },
}
