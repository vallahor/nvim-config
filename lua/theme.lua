local M = {}

local italic_active = "none"
local bold_active = "bold"
local undercurl_active = "undercurl"
local undercurl_bold_active = "undercurl,bold"

local p = {
  other1 = "#821554",
  other2 = "#CC94A0", -- check if really worth and get a new name
  brown = "#7F5446", -- not used
  fg1 = "#A98D92",
  -- fg1 = "#fcbac9",
  fg2 = "#C0AEA0",
  fg3 = "#222022",
  fg4 = "#493441",
  fg5 = "#696059", -- ghost text
  bg0 = "#091010",
  bg1 = "#121112",
  bg2 = "#c64964",
  bg3 = "#382536",
  bg4 = "#291C28",
  bg_original = "#222022",
  match = "#ff8080",
  cursor = "#f4ddcc",
  yellow = "#c58d5d",
  yellow2 = "#AF7C55",
  yellow3 = "#AF655A",
  yellow4 = "#96674E",
  red = "#a1495c",
  red2 = "#b1314c",
  red3 = "#9d2640",
  red4 = "#a23343",
  red5 = "#a03343",
  red6 = "#A45159",
  -- error = "#c6494a",
  error = "#a23343",
  warning = "#AF7C55",
  purple_light = "#806292",
  purple_dark = "#794966",
  pink1 = "#b16D8A",
  pink2 = "#d16d8a",
  green = "#1a563f",
  -- green2 = "#666666",
  green2 = "#445544",
  gray1 = "#363436",
  gray2 = "#3d3339",
  pastel = "#9f8d8c",
  pastel2 = "#887878",
  pink_pastel = "#A8899C",
  pink_pastel2 = "#926C83",
  pink_pastel3 = "#8F5E7B",
  exception = "#96516E",
  pink_half_dark = "#9B668F",
  color1 = "#f4ddcc",
  color2 = "#b9e0d3",
  color3 = "#e8b9b8",
  search = "#43282f",
  -- visual = "#213737", -- dark slate pallet
  -- visual = "#182626",
  -- visual = "#A23343",
  visual = "#471A37",
  visual_mode = "#79586E",
  -- status_line = "#291C28",
  status_line_nc = "#191319",
  status_line = "#381B2F",
  -- winbar_line = "#471A37",
  winbar_line = "#381B2F",
  winbar_line_nc = "#191319",
  -- status_line_nc = "#091010",
  -- status_line = "#1c212f",
  -- status_line = "#222022",
  menu_bg = "#1c212f",
  bracket = "#95667C",
}

local t = {
  ColorColumn = { fg = p.fg2, bg = p.fg4 },
  Conceal = { fg = p.fg2 },
  -- Cursor = { fg = p.fg3, bg = p.color1 },
  Cursor = { fg = p.fg3, bg = p.fg1 },
  iCursor = { bg = p.red2 },
  vCursor = { bg = p.visual_mode },
  -- lCursor = { bg = p.bg3 },
  CursorIM = { bg = p.bg3 },
  CursorColumn = { bg = p.bg3 },
  -- CursorColumn = { bg = p.bg3 },
  -- CursorLine = { bg = p.bg3 },
  CursorLine = { bg = p.bg4 },
  Directory = { fg = p.fg2 },
  NonText = { fg = p.fg2 },
  DiffAdd = { fg = p.color2, bg = p.green },
  DiffChange = { fg = p.color2, bg = p.green },
  DiffDelete = { fg = p.red3 },
  DiffText = { fg = p.fg2 },
  EndOfBuffer = { fg = p.bg1 },
  ErrorMsg = { fg = p.red4 },
  VertSplit = { fg = p.bg3 },
  Folded = { fg = p.fg2 },
  FoldColumn = { fg = p.fg2 },
  SignColumn = { fg = p.fg2 },
  IncSearch = { bg = p.bg2 },
  LineNr = { fg = p.fg4 },
  LineNrAbove = { fg = p.fg4 },
  LineNrBelow = { fg = p.fg4 },
  -- CursorLineNr = { fg = p.red, bg = p.bg3 },
  CursorLineNr = { fg = p.red, bg = p.bg4 },
  MatchParen = { fg = p.match },
  ModeMsg = { fg = p.fg2, bg = p.bg3 },
  MoreMsg = { fg = p.fg2, bg = p.bg3 },
  -- Pmenu = { fg = p.fg2, bg = p.gray1 },
  -- Pmenu = { fg = p.fg2, bg = p.menu_bg },
  -- using blend
  -- Pmenu = { fg = p.fg2 },
  Pmenu = { fg = p.fg2, bg = p.bg4 },
  PmenuSel = { bg = p.fg4 },
  PmenuSbar = { fg = p.fg2, bg = p.bg3 },
  PmenuThumb = { fg = p.fg2 },
  Question = { fg = p.fg2 },
  QuickFixLine = { fg = p.red2 },
  Search = { bg = p.search },
  -- SpecialKey = { fg = p.pink2 },
  SpellBad = { sp = p.red, effect = undercurl_active },
  SpellCap = { sp = p.red, effect = undercurl_active },
  SpellLocal = { sp = p.red, effect = undercurl_active },
  SpellRare = { sp = p.red, effect = undercurl_active },
  StatusLineNC = { bg = p.status_line_nc },
  StatusLine = { bg = p.status_line },
  WinBarNC = { bg = p.winbar_line_nc },
  WinBar = { bg = p.winbar_line },
  -- StatusLine = { bg = p.bg3 },
  StatusLineTerm = { fg = p.fg2, bg = p.bg3 },
  StatusLineTermNC = { bg = p.gray1 },
  -- TabLine = { bg = p.gray2 },
  -- TabLine = { bg = "None" },
  TabLine = { bg = "#191819" }, -- Cokeline fill
  -- TabLine = { bg = p.bg3 },
  -- TabLineFill = { bg = p.fg3 },
  TabLineFill = { bg = p.status_line_nc },
  -- TabLineFill = { bg = p.bg1 },
  TabLineSel = { fg = p.fg2 },
  Terminal = { fg = p.fg2 },
  Title = { fg = p.fg2 },
  -- Visual = { bg = p.search },
  Visual = { bg = p.visual },
  LinewiseVisual = { bg = p.fg1 },
  -- VisualNOS = { bg = p.gray1 },
  VisualNOS = { bg = p.search },
  WarningMsg = { fg = p.pink2 },
  WildMenu = { bg = p.fg4 },
  Normal = { fg = p.fg1, bg = p.bg1 },
  Comment = { fg = p.green2, effect = "italic" },
  Constant = { fg = p.pink_pastel },
  Identifier = { fg = p.fg1 },
  Statement = { fg = p.purple_dark },
  PreProc = { fg = p.yellow4 },
  Type = { fg = p.purple_light },
  Special = { fg = p.purple_light },
  Underlined = { fg = p.fg2 },
  Ignore = { fg = p.fg2 },
  Error = { fg = p.red4 },
  Todo = { fg = p.yellow },
  String = { fg = p.pink1 },
  Character = { fg = p.pink1 },
  Number = { fg = p.pink2 },
  Boolean = { fg = p.pink2 },
  Float = { fg = p.pink2 },
  Function = { fg = p.yellow },
  Conditional = { fg = p.purple_dark, effect = italic_active },
  Repeat = { fg = p.purple_dark, effect = italic_active },
  Label = { fg = p.purple_dark },
  -- Label = { fg = p.bg_original },
  Whitespace = { fg = p.bg_original },
  Operator = { fg = p.purple_dark },
  Keyword = { fg = p.red },
  Exception = { fg = p.exception },
  -- Include = { fg = p.red6, effect = bold_active },
  Include = { fg = p.yellow4, effect = bold_active },
  Define = { fg = p.yellow4 },
  Macro = { fg = p.pink_pastel2 },
  PreCondit = { fg = p.yellow },
  StorageClass = { fg = p.red },
  Structure = { fg = p.red },
  Typedef = { fg = p.red },
  SpecialChar = { fg = p.pink_pastel },
  SpecialKey = { fg = p.pink_pastel },
  Tag = { fg = p.red },
  Delimiter = { fg = p.purple_dark },
  -- SpecialComment = { fg = p.purple_dark, effect = "italic" },
  SpecialComment = { fg = p.green2, effect = "italic" },
  Debug = { fg = p.purple_dark },
  gitcommitSummary = { fg = p.fg2 },
  -- DiagnosticError = { fg = p.red4 },
  DiagnosticError = { fg = p.error },
  -- DiagnosticWarn = { fg = p.yellow2 },
  DiagnosticWarn = { fg = p.warning },
  DiagnosticInfo = { fg = p.pink_pastel },
  DiagnosticHint = { fg = p.fg1 },
  -- DiagnosticHint = { sp = p.fg1, effect = undercurl_active },
  -- DiagnosticUnnecessary = { sp = p.fg1, effect = undercurl_active },
  DiagnosticUnnecessary = {},
  DiagnosticUnderlineError = { sp = p.red4, effect = undercurl_active },
  DiagnosticUnderlineWarn = { sp = p.yellow2, effect = undercurl_active },
  -- DiagnosticUnderlineInfo = { sp = p.pink_pastel, effect = italic_active },
  DiagnosticUnderlineInfo = { sp = p.pink_pastel, effect = undercurl_active },
  DiagnosticUnderlineHint = { sp = p.fg1, effect = undercurl_active },
  -- that's doesn't exist
  DiagnosticUnderlineUnnecessary = { sp = p.fg1, effect = undercurl_active },
  BufferCurrent = { bg = p.gray2 },
  BufferCurrentIndex = { bg = p.gray2 },
  BufferCurrentMod = { fg = p.pink2, bg = p.gray2 },
  BufferCurrentSign = { bg = p.gray2 },
  BufferCurrentTarget = { bg = p.gray2 },
  -- BufferVisible = {                 },
  -- BufferVisibleIndex = {            },
  BufferVisibleMod = { fg = p.pink2, bg = p.gray2 },
  -- BufferVisibleSign = {             },
  -- BufferVisibleTarget = {           },
  IndentBlanklineSpaceChar = { fg = p.purple_dark },
  IndentBlanklineSpaceCharBlankline = { fg = p.purple_dark },
  IndentBlanklineContextSpaceChar = { fg = p.purple_dark },
  IndentBlanklineContextChar = { fg = p.bg_original },
  IndentBlanklineContextStart = { fg = p.bg_original },

  MiniStatuslineModeInsert = { fg = p.bg1, bg = p.red2 },
  MiniStatuslineModeVisual = { bg = p.visual },
  MiniGhostText = { fg = p.fg5 },

  -- NvimTreeVertSplit = { fg = p.fg1, bg = p.bg1 },
  NvimTreeVertSplit = { bg = p.bg1 },

  --- treesitter ---
  -- ["@include"] = { fg = p.red6, effect = bold_active },
  ["@include"] = { fg = p.yellow4, effect = bold_active },
  ["@character"] = { fg = p.pink1 },
  -- ["@define"] = { fg = p.fg2 },
  ["@define"] = { fg = p.yellow4 },
  ["@string"] = { fg = p.pink1 },
  ["@string.regex"] = { fg = p.pink1 },
  ["@string.escape"] = { fg = p.purple_dark },
  -- ["@string.special"] = { fg = p.pink_pastel },
  ["@string.special"] = { fg = p.bracket },
  -- ["@keyword"] = { fg = p.red },
  ["@keyword"] = { fg = p.red, effect = italic_active },
  ["@keyword.function"] = { fg = p.red, effect = italic_active },
  ["@keyword.return"] = { fg = p.purple_dark, effect = italic_active },
  -- ["@keyword.return"] = { fg = p.purple_dark },
  ["@keyword.js"] = { fg = p.purple_dark },
  -- ["@keyword.operator"] = { fg = p.purple_dark },
  ["@keyword.operator"] = { fg = p.purple_dark, effect = italic_active },
  ["@variable"] = { fg = p.fg1 },
  ["@variable.builtin"] = { fg = p.purple_light, effect = italic_active },
  -- ["@variable.builtin"] = { fg = p.pink_half_dark, effect = italic_active },
  ["@symbol"] = { fg = p.pink_pastel2 },
  ["@tag"] = { fg = p.red },
  -- ["@tag"] = { fg = p.yellow, effect = italic_active },
  -- ["@tag.delimiter"] = { fg = p.pastel },
  ["@tag.delimiter"] = { fg = p.bracket },
  ["@tag.attribute"] = { fg = p.pink_pastel },
  -- ["@attribute"] = { fg = p.purple_dark, effect = italic_active },
  -- ["@attribute"] = { fg = p.red },
  ["@attribute"] = { fg = p.purple_dark },
  ["@text"] = { fg = p.fg2 },
  ["@text.strong"] = { fg = p.fg2 },
  ["@text.emphasis"] = { fg = p.fg2 },
  ["@text.underline"] = { fg = p.fg2 },
  -- ["@text.uri"] = { fg = p.pink1, effect = "italic" },
  ["@text.uri"] = { fg = p.pink1 },
  ["@text.title"] = { fg = p.fg2 },
  ["@text.literal"] = { fg = p.pastel },
  -- ["@namespace"] = { fg = p.pink_pastel2 },
  ["@namespace"] = { fg = p.pink_pastel3 },
  ["@type"] = { fg = p.purple_light },
  -- ["@type.qualifier"] = { fg = p.purple_dark, effect = italic_active },
  ["@type.qualifier"] = { fg = p.red },
  -- ["@type.definition"] = { fg = p.red },
  ["@type.definition"] = { fg = p.purple_light },
  ["@type.builtin"] = { fg = p.purple_light },
  ["@structure"] = { fg = p.purple_light },
  -- ["@function"] = { fg = p.yellow },
  ["@function"] = { fg = p.yellow },
  -- ["@function.builtin"] = { fg = p.other2 },
  ["@function.builtin"] = { fg = p.purple_light },
  -- ["@function.builtin"] = { fg = p.red6 },
  ["@function.call"] = { fg = p.yellow },
  ["@function.macro"] = { fg = p.pink_half_dark },
  ["@method"] = { fg = p.yellow },
  ["@method.call"] = { fg = p.yellow },
  -- ["@constructor"] = { fg = p.yellow }, -- @check if it's look better in some languages
  ["@constructor"] = { fg = p.purple_light },
  ["@field"] = { fg = p.pink_pastel2 },
  ["@property"] = { fg = p.pink_pastel2 },
  ["@parameter"] = { fg = p.fg1 },
  ["@parameter.reference"] = { fg = p.pastel },
  ["@number"] = { fg = p.pink2 },
  ["@float"] = { fg = p.pink2 },
  ["@boolean"] = { fg = p.pink2 },
  ["@constant"] = { fg = p.pink_pastel },
  ["@constant.builtin"] = { fg = p.pink_half_dark },
  -- ["@constant.macro"] = { fg = p.yellow },
  ["@constant.macro"] = { fg = p.yellow3 },
  ["@punctuation.delimiter"] = { fg = p.purple_dark },
  ["@punctuation.bracket"] = { fg = p.bracket },
  ["@punctuation.special"] = { fg = p.purple_dark },
  ["@operator"] = { fg = p.purple_dark },
  ["@conditional"] = { fg = p.purple_dark, effect = italic_active },
  ["@repeat"] = { fg = p.purple_dark, effect = italic_active },
  -- ["@exception"] = {fg = p.purple_dark},
  ["@exception"] = { fg = p.exception },
  -- ["@label"] = { fg = p.pink_pastel },
  ["@label"] = { fg = p.exception },
  ["@macro"] = { fg = p.pink_pastel2 },
  ["@todo"] = { fg = p.yellow3 },
  ["@preproc"] = { fg = p.yellow4 },
  ["@debug"] = { fg = p.purple_dark },
  ["@storageclass"] = { fg = p.red, effect = italic_active },
  ["@storageclass.lifetime"] = { fg = p.pink_half_dark, effect = italic_active },
  -- ["@comment"] = { fg = p.green2, effect = "italic" },
  ["@comment"] = { fg = p.green2, effect = "italic" },
}

local function highlight(group, style)
  local effect = style.effect and "gui=" .. style.effect or "gui=NONE"
  local fg = style.fg and "guifg=" .. style.fg or "guifg=NONE"
  local bg = style.bg and "guibg=" .. style.bg or "guibg=NONE"
  local sp = style.sp and "guisp=" .. style.sp or "guisp=NONE"

  vim.cmd(string.format("highlight %s %s %s %s %s", group, effect, fg, bg, sp))
  return string.format("highlight %s %s %s %s %s", group, effect, fg, bg, sp)
  -- Hide all semantic highlights
  -- for _, color_group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  --   vim.api.nvim_set_hl(0, color_group, {})
  -- end

  -- local links = {
  -- 	["@lsp.type.namespace"] = "@namespace",
  -- 	["@lsp.mod.namespace"] = "@namespace",
  -- 	["@lsp.typemod.type.namespace"] = "@namespace",
  -- 	["@lsp.type.type"] = "@type",
  -- 	-- ["@lsp.type.keyword"] = "@keyword",
  -- 	["@lsp.type.class"] = "@type",
  -- 	["@lsp.type.enum"] = "@type",
  -- 	["@lsp.type.interface"] = "@type",
  -- 	["@lsp.type.struct"] = "@structure",
  -- 	["@lsp.type.parameter"] = "@parameter",
  -- 	["@lsp.type.variable"] = "@variable",
  -- 	["@lsp.type.property"] = "@property",
  -- 	["@lsp.type.enumMember"] = "@constant",
  -- 	["@lsp.type.function"] = "@function",
  -- 	["@lsp.type.method"] = "@method",
  -- 	["@lsp.type.macro"] = "@macro",
  -- 	["@lsp.type.decorator"] = "@function",
  -- 	["@lsp.typemod.variable.defaultLibrary"] = "@variable",
  -- 	["@lsp.typemod.variable.definition"] = "@punctuation.delimiter",
  -- 	["@lsp.typemod.function.defaultLibrary"] = "@function.builtin",
  -- 	["@lsp.typemod.function.async"] = "@function",
  -- }
  -- for newgroup, oldgroup in pairs(links) do
  -- 	vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
  -- end
end

function M.colorscheme()
  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  vim.g.colors_name = "kamarelo"
  local aeho = ""
  for group, style in pairs(t) do
    local a = highlight(group, style)
    aeho = aeho .. "\n" .. a
  end
  -- print(aeho)
  local file = io.open("AEHO.vim", "w")
  file:write(aeho)
  file:close()
end

return M
