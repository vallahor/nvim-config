local M = {}

local italic_active = "none"
local bold_active = "bold"
local undercurl_active = "undercurl"
local undercurl_bold_active = "undercurl,bold"

local p = {
	fg1 = "#A98D92",
	fg2 = "#C0AEA0",
	fg3 = "#222022",
	fg4 = "#493441",
	bg1 = "#121112",
	-- bg1 = "#091010",
	bg2 = "#c64964",
	bg3 = "#382536",
	bg4 = "#291C28",
	bg_original = "#222022",
	match = "#ff8080",
	cursor = "#f4ddcc",
	yellow = "#c58d5d",
	yellow2 = "#AF7C55",
	red = "#a1495c",
	red2 = "#b1314c",
	red3 = "#9d2640",
	purple_dark = "#794966",
	purple_light = "#806292",
	pink1 = "#b16D8A",
	pink2 = "#d16d8a",
	green = "#1a563f",
	gray1 = "#363436",
	gray2 = "#3d3339",
	pastel = "#9f8d8c",
	pastel2 = "#887878",
	pink_pastel = "#A8899C",
	pink_pastel2 = "#926C83",
	exception = "#96516E",
	pink_half_dark = "#9B668F",
	color1 = "#f4ddcc",
	color2 = "#b9e0d3",
	color3 = "#e8b9b8",
	search = "#43282f",
	-- visual = "#213737", -- dark slate pallet
	visual = "#182626",
	status_line_nc = "#191319",
	status_line = "#291C28",
	-- status_line_nc = "#091010",
	-- status_line = "#1c212f",
	menu_bg = "#1c212f",
	bracket = "#95667C",
}

local t = {
	ColorColumn = { fg = p.fg2, bg = p.fg4 },
	Conceal = { fg = p.fg2 },
	Cursor = { fg = p.fg3, bg = p.color1 },
	iCursor = { bg = p.red2 },
	lCursor = { bg = p.bg3 },
	CursorIM = { bg = p.bg3 },
	CursorColumn = { bg = p.bg3 },
	-- CursorColumn = { bg = p.bg3 },
	-- CursorLine = { bg = p.bg3 },
	CursorLine = { bg = p.bg4 },
	Directory = { fg = p.fg2 },
	DiffAdd = { fg = p.color2, bg = p.green },
	DiffChange = { fg = p.fg2 },
	DiffDelete = { fg = p.color3, bg = p.red3 },
	DiffText = { fg = p.fg2 },
	EndOfBuffer = { fg = p.fg4 },
	ErrorMsg = { fg = p.red2 },
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
	Pmenu = { fg = p.fg2, bg = p.menu_bg },
	PmenuSel = { bg = p.fg4 },
	PmenuSbar = { fg = p.fg2, bg = p.bg3 },
	PmenuThumb = { fg = p.fg2 },
	Question = { fg = p.fg2 },
	QuickFixLine = { fg = p.red2 },
	Search = { bg = p.search },
	SpecialKey = { fg = p.pink2 },
	SpellBad = { sp = p.red, effect = undercurl_active },
	SpellCap = { sp = p.red, effect = undercurl_active },
	SpellLocal = { sp = p.red, effect = undercurl_active },
	SpellRare = { sp = p.red, effect = undercurl_active },
	StatusLineNC = { bg = p.status_line_nc },
	StatusLine = { bg = p.status_line },
	-- StatusLine = { bg = p.bg3 },
	StatusLineTerm = { fg = p.fg2, bg = p.bg3 },
	StatusLineTermNC = { bg = p.gray1 },
	TabLine = { bg = p.gray2 },
	TabLineFill = { bg = p.fg3 },
	TabLineSel = { fg = p.fg2 },
	Terminal = { fg = p.fg2 },
	Title = { fg = p.fg2 },
	-- Visual = { bg = p.search },
	Visual = { bg = p.visual },
	-- VisualNOS = { bg = p.gray1 },
	VisualNOS = { bg = p.search },
	WarningMsg = { fg = p.pink2 },
	WildMenu = { bg = p.fg4 },
	Normal = { fg = p.fg1, bg = p.bg1 },
	Comment = { fg = p.pastel },
	Constant = { fg = p.pink_pastel },
	Identifier = { fg = p.fg1 },
	Statement = { fg = p.purple_dark },
	PreProc = { fg = p.yellow },
	Type = { fg = p.purple_light },
	Special = { fg = p.purple_light },
	Underlined = { fg = p.fg2 },
	Ignore = { fg = p.fg2 },
	Error = { fg = p.red2 },
	Todo = { fg = p.yellow },
	String = { fg = p.pink1 },
	Character = { fg = p.pink1 },
	Number = { fg = p.pink2 },
	Boolean = { fg = p.pink2 },
	Float = { fg = p.pink2 },
	Function = { fg = p.yellow },
	Conditional = { fg = p.purple_dark, effect = italic_active },
	Repeat = { fg = p.purple_dark, effect = italic_active },
	-- Label = { fg = p.purple_dark },
	Label = { fg = p.bg_original },
	Whitespace = { fg = p.bg_original },
	Operator = { fg = p.purple_dark },
	Keyword = { fg = p.red },
	Exception = { fg = p.exception },
	Include = { fg = p.yellow, effect = bold_active },
	Define = { fg = p.fg2 },
	Macro = { fg = p.pink_pastel2 },
	PreCondit = { fg = p.yellow },
	StorageClass = { fg = p.red },
	Structure = { fg = p.red },
	Typedef = { fg = p.red },
	SpecialChar = { fg = p.pink_pastel },
	SpecialKey = { fg = p.pink_pastel },
	Tag = { fg = p.red },
	Delimiter = { fg = p.purple_dark },
	SpecialComment = { fg = p.purple_dark },
	Debug = { fg = p.purple_dark },
	gitcommitSummary = { fg = p.fg2 },
	DiagnosticError = { fg = p.red },
	DiagnosticWarn = { fg = p.yellow },
	DiagnosticInfo = { fg = p.pink_pastel },
	DiagnosticHint = { fg = p.fg1 },
	-- DiagnosticUnderlineError = { sp = p.red },
	-- DiagnosticUnderlineWarn = { sp = p.yellow },
	-- DiagnosticUnderlineInfo = { sp = p.pink_pastel },
	-- DiagnosticUnderlineHint = { sp = p.fg1 },
	DiagnosticUnderlineError = { sp = p.red, effect = undercurl_active },
	DiagnosticUnderlineWarn = { sp = p.yellow, effect = undercurl_active },
	DiagnosticUnderlineInfo = { sp = p.pink_pastel, effect = italic_active },
	DiagnosticUnderlineHint = { sp = p.yellow2, effect = undercurl_active },

	--- treesitter ---
	["@include"] = { fg = p.yellow, effect = bold_active },
	["@character"] = { fg = p.pink1 },
	["@define"] = { fg = p.fg2 },
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
	["@symbol"] = { fg = "#00ff00" },
	["@tag"] = { fg = p.red },
	-- ["@tag"] = { fg = p.yellow, effect = italic_active },
	-- ["@tag.delimiter"] = { fg = p.pastel },
	["@tag.delimiter"] = { fg = p.bracket },
	["@tag.attribute"] = { fg = p.pink_pastel },
	["@attribute"] = { fg = p.purple_dark, effect = italic_active },
	["@text"] = { fg = p.fg2 },
	["@text.strong"] = { fg = p.fg2 },
	["@text.emphasis"] = { fg = p.fg2 },
	["@text.underline"] = { fg = p.fg2 },
	["@text.uri"] = { fg = p.fg2 },
	["@text.title"] = { fg = p.fg2 },
	["@text.literal"] = { fg = p.pastel },
	["@namespace"] = { fg = p.pink_pastel2 },
	["@type"] = { fg = p.purple_light },
	["@type.qualifier"] = { fg = p.purple_dark, effect = italic_active },
	-- ["@type.definition"] = { fg = p.red },
	["@type.definition"] = { fg = p.purple_light },
	["@type.builtin"] = { fg = p.purple_light },
	["@function"] = { fg = p.yellow },
	["@function.builtin"] = { fg = p.yellow },
	["@function.call"] = { fg = p.yellow },
	["@function.macro"] = { fg = p.pink_half_dark },
	["@method"] = { fg = p.yellow },
	["@constructor"] = { fg = p.purple_light },
	["@field"] = { fg = p.pink_pastel2 },
	["@property"] = { fg = p.pink_pastel2 },
	["@parameter"] = { fg = p.fg1 },
	["@parameter.reference"] = { fg = p.pastel },
	["@number"] = { fg = p.pink2 },
	["@float"] = { fg = p.pink2 },
	["@boolean"] = { fg = p.pink1 },
	["@constant"] = { fg = p.pink_pastel },
	["@constant.builtin"] = { fg = p.pink_half_dark },
	["@constant.macro"] = { fg = p.yellow },
	["@punctuation.delimiter"] = { fg = p.purple_dark },
	["@punctuation.bracket"] = { fg = p.bracket },
	["@punctuation.special"] = { fg = p.purple_dark },
	["@operator"] = { fg = p.purple_dark },
	["@conditional"] = { fg = p.purple_dark, effect = italic_active },
	["@repeat"] = { fg = p.purple_dark, effect = italic_active },
	-- ["@exception"] = {fg = p.purple_dark},
	["@exception"] = { fg = p.exception },
	["@label"] = { fg = p.pink_pastel },
	["@macro"] = { fg = p.pink_pastel2 },
	["@todo"] = { fg = p.yellow },
	["@preproc"] = { fg = p.yellow },
	["@debug"] = { fg = p.purple_dark },
	["@storageclass"] = { fg = p.red, effect = italic_active },
	["@storageclass.lifetime"] = { fg = p.pink_half_dark, effect = italic_active },
	["@comment"] = { fg = p.pastel2 },
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
}

local function highlight(group, style)
	local effect = style.effect and "gui=" .. style.effect or "gui=NONE"
	local fg = style.fg and "guifg=" .. style.fg or "guifg=NONE"
	local bg = style.bg and "guibg=" .. style.bg or "guibg=NONE"
	local sp = style.sp and "guisp=" .. style.sp or "guisp=NONE"

	vim.cmd(string.format("highlight %s %s %s %s %s", group, effect, fg, bg, sp))
end

function M.colorscheme()
	if vim.g.colors_name then
		vim.cmd("highlight clear")
	end
	vim.g.colors_name = "kamarelo"
	for group, style in pairs(t) do
		highlight(group, style)
	end
end

return M
