vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/RRethy/nvim-treesitter-endwise",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/folke/ts-comments.nvim",
})

local languages = {
  "bash",
  "blade",
  "c",
  "cpp",
  "css",
  "html",
  "hyprlang",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "nu",
  "odin",
  "python",
  "query",
  "rust",
  "svelte",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "zig",
}

local already_installed = require("nvim-treesitter.config").get_installed()
local parsers_to_install = vim
  .iter(languages)
  :filter(function(parser)
    return not vim.tbl_contains(already_installed, parser)
  end)
  :totable()
require("nvim-treesitter").install(parsers_to_install)

local disable_indent = {
  cpp = true,
  gdscript = true,
  odin = true,
  python = true,
  rust = true,
  zig = true,
}

local patterns = {}
for _, parser in ipairs(languages) do
  local parser_patterns = vim.treesitter.language.get_filetypes(parser)
  for _, pp in pairs(parser_patterns) do
    table.insert(patterns, pp)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = patterns,
  callback = function(ev)
    vim.treesitter.start()
    local lang = vim.bo[ev.buf].filetype
    if not disable_indent[lang] then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("nvim-ts-autotag").setup()
require("nvim-treesitter.endwise")
require("ts-comments").setup()
