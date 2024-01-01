return {
  -- "vallahor/caramelo",
  dir = "../../colors/caramelo.vim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme caramelo]])
  end,
}
