return {
  -- "vallahor/caramelo",
  -- dir = "D:/projects/caramelo/colors/caramelo.vim",
  dir = "../../colors/caramelo.vim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme caramelo]])
  end,
}
