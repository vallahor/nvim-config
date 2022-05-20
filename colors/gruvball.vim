
"""
" Name: gruvball.vim
"""

set background=dark
hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='gruvball'
set t_Co=256

" misc

hi ColorColumn      guisp=NONE guifg=#C0AEA0     guibg=#493441 ctermfg=NONE ctermbg=95 gui=NONE cterm=NONE
hi Conceal          guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Cursor           guisp=NONE guifg=#222022  guibg=#f4ddcc ctermfg=235 ctermbg=145  gui=NONE cterm=NONE
hi iCursor         guisp=NONE guifg=NONE     guibg=#b1314c ctermfg=145 ctermbg=131 gui=NONE cterm=NONE
hi lCursor          guisp=NONE guifg=NONE     guibg=#382536 ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi CursorIM         guisp=NONE guifg=NONE     guibg=#382536 ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi CursorColumn     guisp=NONE guifg=NONE     guibg=#382536 ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi CursorLine       guisp=NONE guifg=NONE     guibg=#382536 ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Directory        guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi DiffAdd          guisp=NONE guifg=#b9e0d3  guibg=#1a563f ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
hi DiffChange       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi DiffDelete       guisp=NONE guifg=#e8b9b8  guibg=#9d2640 ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
hi DiffText         guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi EndOfBuffer      guisp=NONE guifg=#493441  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi ErrorMsg         guisp=NONE guifg=#b1314c  guibg=NONE    ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
hi VertSplit        guisp=NONE guifg=#382536  guibg=NONE    ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
hi Folded           guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi FoldColumn       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi SignColumn       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi IncSearch        guisp=NONE guifg=NONE     guibg=#c64964 ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
hi LineNr           guisp=NONE guifg=#493441  guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi LineNrAbove      guisp=NONE guifg=#493441  guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi LineNrBelow      guisp=NONE guifg=#493441  guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi CursorLineNr     guisp=NONE guifg=#a1495c  guibg=#382536 ctermfg=95  ctermbg=236 gui=NONE cterm=NONE
hi MatchParen       guisp=NONE guifg=#ff8080  guibg=#040004 ctermfg=210 ctermbg=NONE gui=NONE cterm=NONE
hi ModeMsg          guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236 gui=NONE cterm=NONE
hi MoreMsg          guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236 gui=NONE cterm=NONE
hi NonText          guisp=NONE guifg=NONE     guibg=NONE    ctermfg=NONE ctermbg=NONE  gui=NONE cterm=NONE
hi Pmenu            guisp=NONE guifg=#C0AEA0  guibg=#363436 ctermfg=145 ctermbg=237 gui=NONE cterm=NONE
hi PmenuSel         guisp=NONE guifg=NONE     guibg=#493441 ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi PmenuSbar        guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236 gui=NONE cterm=NONE
hi PmenuThumb       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Question         guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi QuickFixLine     guisp=NONE guifg=#b1314c  guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi Search           guisp=NONE guifg=#c64964  guibg=NONE ctermfg=167 ctermbg=NONE  gui=NONE cterm=NONE
hi SpecialKey       guisp=NONE guifg=#d16d8a  guibg=NONE    ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
"hi SpellBad         guisp=NONE guifg=#b1314c  guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi SpellBad         guisp=#a1495c guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline
hi SpellCap         guisp=#a1495c guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline
hi SpellLocal       guisp=#a1495c guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline
hi SpellRare        guisp=#a1495c guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline
hi StatusLine       guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236 gui=NONE cterm=NONE
hi StatusLineNC     guisp=NONE guifg=NONE     guibg=#363436 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi StatusLineTerm   guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236 gui=NONE cterm=NONE
hi StatusLineTermNC guisp=NONE guifg=NONE     guibg=#363436 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi TabLine          guisp=NONE guifg=#3d3339  guibg=NONE    ctermfg=237 ctermbg=NONE gui=NONE cterm=NONE
hi TabLineFill      guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TabLineSel       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Terminal         guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Title            guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Visual           guisp=NONE guifg=NONE     guibg=#363436 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi VisualNOS        guisp=NONE guifg=NONE     guibg=#363436 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi WarningMsg       guisp=NONE guifg=#d16d8a  guibg=NONE    ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
hi WildMenu         guisp=NONE guifg=NONE     guibg=#493441 ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE

" major

hi Normal     guisp=NONE guifg=#C0AEA0 guibg=#222022 ctermfg=139 ctermbg=235  gui=NONE cterm=NONE
hi Comment    guisp=NONE guifg=#9f8d8c guibg=NONE    ctermfg=246 ctermbg=NONE gui=NONE cterm=NONE
hi Constant   guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi Identifier guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Statement  guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi PreProc    guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=bold cterm=bold
hi Type       guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi Special    guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi Underlined guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Ignore     guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Error      guisp=NONE guifg=#b1314c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi Todo       guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE  gui=NONE cterm=NONE

" minor

hi String         guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi Character      guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE  gui=NONE cterm=NONE
hi Number         guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi Boolean        guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi Float          guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi Function       guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
hi Conditional    guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
hi Repeat         guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
hi Label          guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
hi Operator       guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
hi Keyword        guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi Exception      guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
hi Include        guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=bold cterm=bold
hi Define         guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Macro          guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi PreCondit      guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=bold cterm=bold
hi StorageClass   guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi Structure      guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi Typedef        guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi SpecialChar    guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi Tag            guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi Delimiter      guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi SpecialComment guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi Debug          guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE

hi gitcommitSummary guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE

hi DiagnosticError guisp=NONE guifg=#794966 guibg=NONE ctermfg=95 ctermbg=NONE gui=italic cterm=italic
hi DiagnosticWarn  guisp=NONE guifg=#794966 guibg=NONE ctermfg=95 ctermbg=NONE gui=italic cterm=italic
hi DiagnosticInfo  guisp=NONE guifg=#794966 guibg=NONE ctermfg=95 ctermbg=NONE gui=italic cterm=italic
hi DiagnosticHint  guisp=NONE guifg=#794966 guibg=NONE ctermfg=95 ctermbg=NONE gui=italic cterm=italic

hi DiagnosticUnderlineError guisp=#a1495c guifg=#794966 guibg=NONE ctermfg=95 ctermbg=NONE gui=undercurl,bold cterm=underline,bold
hi DiagnosticUnderlineWarn  guisp=#a1495c guifg=#794966 guibg=NONE ctermfg=95 ctermbg=NONE gui=undercurl,bold cterm=underline,bold
hi DiagnosticUnderlineInfo  guisp=#a1495c guifg=#794966 guibg=NONE ctermfg=95 ctermbg=NONE gui=italic cterm=italic
hi DiagnosticUnderlineHint  guisp=#a1495c guifg=#794966 guibg=NONE ctermfg=95 ctermbg=NONE gui=undercurl,bold cterm=underline,bold


hi TSInclude             guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi TSString              guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi TSStringRegex         guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi TSStringEscape        guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi TSStringSpecial       guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi TSKeyword             guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=italic cterm=italic
hi TSKeywordFunction     guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=italic cterm=italic
hi TSKeywordReturn       guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold,italic cterm=bold,italic
"hi TSKeywordReturn       guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
hi TSKeywordOperator     guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold     
hi TSVariable            guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSVariableBuiltin     guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSTag                 guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi TSTagDelimiter        guisp=NONE guifg=#9F8D8C guibg=NONE    ctermfg=246 ctermbg=NONE gui=NONE cterm=NONE
hi TSTagAttribute        guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi TSAttribute        guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold,italic cterm=bold,italic
hi TSText                guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSStrong              guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSEmphasis            guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSUnderline           guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSLiteral             guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSURI                 guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSTitle               guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSNamespace           guisp=NONE guifg=#9F8D8C guibg=NONE    ctermfg=246 ctermbg=NONE gui=NONE cterm=NONE
hi TSType                guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi TSTypeBuiltin         guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi TSFunction            guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
" hi TSFuncBuiltin         guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE  
 hi TSFuncBuiltin         guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
 hi TSFunctionMacro       guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
hi TSMethod              guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
hi TSConstructor         guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi TSField               guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi TSProperty            guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi TSParameter           guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi TSParameterReference  guisp=NONE guifg=#9F8D8C guibg=NONE    ctermfg=246 ctermbg=NONE gui=NONE cterm=NONE
hi TSNumber              guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi TSFloat               guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
" hi TSBoolean             guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi TSConstant            guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi TSConstBuiltin        guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=bold cterm=bold
hi TSBoolean        guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=bold cterm=bold
hi TSConstMacro          guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi TSPunctDelimiter      guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi TSPunctBracket        guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi TSPunctSpecial        guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold  
hi TSOperator            guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
"hi TSOperator            guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
hi TSConditional         guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold,italic cterm=bold,italic
hi TSRepeat              guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold,italic cterm=bold,italic
hi TSFuncMacro           guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold,italic cterm=bold,italic
hi TSException           guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold,italic cterm=bold,italic
hi TSLabel               guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE

hi TSElement guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=italic cterm=italic

"TelescopeResultsNormal       
"TelescopeResultsBorder
"TelescopeResultsTitle

"TelescopePromptNormal       
"TelescopePromptBorder
"TelescopePromptTitle

"TelescopePreviewNormal       
"TelescopePreviewBorder
"TelescopePreviewTitle
