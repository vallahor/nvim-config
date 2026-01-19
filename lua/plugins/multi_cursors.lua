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

      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      -- hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })

      mc.onSafeState(function()
        local disable = mc.hasCursors()
        if vim.b.minicursorword_disable == disable then
          return
        end

        vim.b.minicursorword_disable = disable
        vim.api.nvim_exec_autocmds("CursorMoved", { buffer = 0 })
      end)
    end,
  },
}
