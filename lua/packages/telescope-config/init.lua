require "telescope".setup {
  defaults = {
    mappings = {
      i = {
        ["<C-bs>"] = function()
          vim.api.nvim_input "<c-s-w>"
        end,
      },
    },
    file_ignore_patterns = { "android", "ios" }
  }
}
