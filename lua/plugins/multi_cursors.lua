return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Disable and enable cursors.
      vim.keymap.set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Add a cursor for all matches of cursor word/selection in the document.
      vim.keymap.set({ "n", "x" }, "<c-u>", mc.matchAllAddCursors)
      -- bring back cursors if you accidentally clear them
      vim.keymap.set("n", "Z", mc.restoreCursors)

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
      vim.keymap.set({ "n", "x" }, "<c-.>", function()
        mc.matchAddCursor(1)
      end)
      vim.keymap.set({ "n", "x" }, "<c->>", function()
        mc.matchSkipCursor(1)
      end)
      vim.keymap.set({ "n", "x" }, "<c-,>", function()
        mc.matchAddCursor(-1)
      end)
      vim.keymap.set({ "n", "x" }, "<c-<>", function()
        mc.matchSkipCursor(-1)
      end)

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

      -- Align cursor columns.
      vim.keymap.set("n", "<c-s-a>", mc.alignCursors)

      vim.keymap.set({ "n", "x" }, "gA", mc.sequenceIncrement)
      vim.keymap.set({ "n", "x" }, "gX", mc.sequenceDecrement)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<a-left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<a-right>", mc.nextCursor)

        -- -- Delete the main cursor.
        -- layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        -- layerSet("n", "<esc>", function()
        --   if not mc.cursorsEnabled() then
        --     mc.enableCursors()
        --   else
        --     mc.clearCursors()
        --   end
        -- end)
        layerSet("n", "<esc>", function()
          mc.clearCursors()
        end)
        layerSet("n", "<c-s-q>", function()
          mc.enableCursors()
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}
