return {
  "s1n7ax/nvim-terminal",
  config = function()
    require("nvim-terminal").setup({
      window = {
        -- Do `:h :botright` for more information
        -- NOTE: width or height may not be applied in some "pos"
        position = "botright",
        -- Do `:h split` for more information
        split = "sp",
        -- Width of the terminal
        width = 50,
        -- Height of the terminal
        height = 15,
      },
      -- keymap to disable all the default keymaps
      disable_default_keymaps = false,
      -- keymap to toggle open and close terminal window
      toggle_keymap = "<c-;>",
      -- increase the window height by when you hit the keymap
      window_height_change_amount = 2,
      -- increase the window width by when you hit the keymap
      window_width_change_amount = 2,
      -- keymap to increase the window width
      increase_width_keymap = "<s-right>",
      -- keymap to decrease the window width
      decrease_width_keymap = "<s-left>",
      -- keymap to increase the window height
      increase_height_keymap = "<s-up>",
      -- keymap to decrease the window height
      decrease_height_keymap = "<s-down>",
      terminals = {
        -- keymaps to open nth terminal
        { keymap = "<c-1>" },
        { keymap = "<c-2>" },
      },
    })
    vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
  end,
}
