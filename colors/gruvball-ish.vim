set background=dark
hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='gruvball-ish'
set t_Co=256

hi ColorColumn      guisp=NONE guifg=#C0AEA0  guibg=#493441 ctermfg=NONE ctermbg=95  gui=NONE cterm=NONE
hi Conceal          guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Cursor           guisp=NONE guifg=#222022  guibg=#f4ddcc ctermfg=235 ctermbg=145  gui=NONE cterm=NONE
hi iCursor          guisp=NONE guifg=NONE     guibg=#b1314c ctermfg=NONE ctermbg=131 gui=NONE cterm=NONE
hi lCursor          guisp=NONE guifg=NONE     guibg=#382536 ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi CursorIM         guisp=NONE guifg=NONE     guibg=#382536 ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi CursorColumn     guisp=NONE guifg=NONE     guibg=#382536 ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi CursorLine       guisp=NONE guifg=NONE     guibg=#382536 ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Directory        guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi DiffAdd          guisp=NONE guifg=#b9e0d3  guibg=#1a563f ctermfg=231 ctermbg=NONE gui=NONE cterm=NONE
hi DiffChange       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi DiffDelete       guisp=NONE guifg=#e8b9b8  guibg=#9d2640 ctermfg=231 ctermbg=NONE gui=NONE cterm=NONE
hi DiffText         guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi EndOfBuffer      guisp=NONE guifg=#493441  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi ErrorMsg         guisp=NONE guifg=#b1314c  guibg=NONE    ctermfg=231 ctermbg=NONE gui=NONE cterm=NONE
hi VertSplit        guisp=NONE guifg=#382536  guibg=NONE    ctermfg=231 ctermbg=NONE gui=NONE cterm=NONE
hi Folded           guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi FoldColumn       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi SignColumn       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi IncSearch        guisp=NONE guifg=NONE     guibg=#c64964 ctermfg=231 ctermbg=NONE gui=NONE cterm=NONE
hi LineNr           guisp=NONE guifg=#493441  guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi LineNrAbove      guisp=NONE guifg=#493441  guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi LineNrBelow      guisp=NONE guifg=#493441  guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi CursorLineNr     guisp=NONE guifg=#a1495c  guibg=#382536 ctermfg=95  ctermbg=236  gui=NONE cterm=NONE
hi MatchParen       guisp=NONE guifg=#ff8080  guibg=NONE    ctermfg=210 ctermbg=NONE gui=NONE cterm=NONE
" hi MatchParen       guisp=NONE guifg=#ff8080  guibg=#040004 ctermfg=210 ctermbg=NONE gui=NONE cterm=NONE
hi ModeMsg          guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236  gui=NONE cterm=NONE
hi MoreMsg          guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236  gui=NONE cterm=NONE
hi NonText          guisp=NONE guifg=NONE     guibg=NONE    ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi Pmenu            guisp=NONE guifg=#C0AEA0  guibg=#363436 ctermfg=145 ctermbg=237  gui=NONE cterm=NONE
hi PmenuSel         guisp=NONE guifg=NONE     guibg=#493441 ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi PmenuSbar        guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236  gui=NONE cterm=NONE
hi PmenuThumb       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Question         guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi QuickFixLine     guisp=NONE guifg=#b1314c  guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi Search           guisp=NONE guifg=NONE     guibg=#43282f ctermfg=NONE ctermbg=236 gui=NONE cterm=NONE
hi SpecialKey       guisp=NONE guifg=#d16d8a  guibg=NONE    ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
hi SpellBad         guisp=#a1495c guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline
hi SpellCap         guisp=#a1495c guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline
hi SpellLocal       guisp=#a1495c guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline
hi SpellRare        guisp=#a1495c guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=undercurl cterm=underline
hi StatusLineNC     guisp=NONE guifg=NONE     guibg=#191319 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi StatusLine       guisp=NONE guifg=NONE  guibg=#291C28 ctermfg=NONE ctermbg=236 gui=NONE cterm=NONE
hi StatusLineTerm   guisp=NONE guifg=#C0AEA0  guibg=#382536 ctermfg=145 ctermbg=236 gui=NONE cterm=NONE
hi StatusLineTermNC guisp=NONE guifg=NONE     guibg=#363436 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi TabLine          guisp=NONE guifg=NONE  guibg=#3d3339    ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi TabLineFill      guisp=NONE guifg=NONE  guibg=#222022    ctermfg=NONE ctermbg=235 gui=NONE cterm=NONE
hi TabLineSel       guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Terminal         guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Title            guisp=NONE guifg=#C0AEA0  guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Visual           guisp=NONE guifg=NONE     guibg=#363436 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi VisualNOS        guisp=NONE guifg=NONE     guibg=#363436 ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi WarningMsg       guisp=NONE guifg=#d16d8a  guibg=NONE    ctermfg=231 ctermbg=NONE  gui=NONE cterm=NONE
hi WildMenu         guisp=NONE guifg=NONE     guibg=#493441 ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE

hi Normal     guisp=NONE guifg=#A98D92 guibg=#121112 ctermfg=138 ctermbg=235  gui=NONE cterm=NONE
hi Comment    guisp=NONE guifg=#9f8d8c guibg=NONE    ctermfg=246 ctermbg=NONE gui=NONE cterm=NONE
hi Constant   guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi Identifier     guisp=NONE guifg=#A98D92 guibg=#121112 ctermfg=138 ctermbg=235  gui=NONE cterm=NONE
hi Statement  guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi PreProc    guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=bold cterm=bold
hi Type       guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi Special         guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi Underlined guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Ignore     guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Error      guisp=NONE guifg=#b1314c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi Todo       guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE  gui=NONE cterm=NONE

hi String         guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi Character      guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE  gui=NONE cterm=NONE
hi Number         guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi Boolean        guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi Float          guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi Function       guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
hi Conditional    guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=italic cterm=italic
hi Repeat              guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=italic cterm=italic
hi Label          guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi Operator       guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi Keyword             guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi Exception      guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi Include             guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi Define         guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi @define         guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi Macro          guisp=NONE guifg=#926C83 guibg=NONE    ctermfg=96 ctermbg=NONE gui=NONE cterm=NONE

hi PreCondit      guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=bold cterm=bold
hi StorageClass   guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi Structure      guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi Typedef        guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi SpecialChar       guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi Tag                guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi Delimiter        guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
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

hi @include             guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi @character      guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE  gui=NONE cterm=NONE
hi @string              guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi @string.regex         guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi @string.escape        guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi @string.special       guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi @keyword             guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi @keyword.function     guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi @keyword.return       guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=italic cterm=italic
hi @keyword.operator     guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi @variable            guisp=NONE guifg=#A98D92 guibg=NONE    ctermfg=138 ctermbg=NONE gui=NONE cterm=NONE
hi @variable.builtin     guisp=NONE guifg=#806292 guibg=NONE    ctermfg=145 ctermbg=NONE gui=italic cterm=italic
hi @tag                 guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=NONE cterm=NONE
hi @tag.delimiter        guisp=NONE guifg=#9F8D8C guibg=NONE    ctermfg=246 ctermbg=NONE gui=NONE cterm=NONE
hi @tag.attribute        guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi @attribute        guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold,italic cterm=bold,italic
hi @text                guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi @text.strong              guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi @text.emphasis              guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi @text.underline              guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi @text.uri              guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi @text.title              guisp=NONE guifg=#C0AEA0 guibg=NONE    ctermfg=145 ctermbg=NONE gui=NONE cterm=NONE
hi @text.literal    guisp=NONE guifg=#9f8d8c guibg=NONE    ctermfg=246 ctermbg=NONE gui=NONE cterm=NONE
hi @namespace            guisp=NONE guifg=#926C83 guibg=NONE    ctermfg=96 ctermbg=NONE gui=NONE cterm=NONE
hi @type                guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi @type.qualifier    guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=italic cterm=italic
hi @type.definition        guisp=NONE guifg=#a1495c guibg=NONE    ctermfg=131 ctermbg=NONE gui=bold cterm=bold
hi @type.builtin         guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi @function            guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
hi @function.builtin         guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
hi @function.macro        guisp=NONE guifg=#9B668F guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi @method              guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE gui=NONE cterm=NONE
hi @constructor         guisp=NONE guifg=#806292 guibg=NONE    ctermfg=96  ctermbg=NONE gui=NONE cterm=NONE
hi @field               guisp=NONE guifg=#926C83 guibg=NONE    ctermfg=96 ctermbg=NONE gui=NONE cterm=NONE
hi @property               guisp=NONE guifg=#926C83 guibg=NONE    ctermfg=96 ctermbg=NONE gui=NONE cterm=NONE
hi @parameter            guisp=NONE guifg=#A98D92 guibg=NONE    ctermfg=138 ctermbg=NONE gui=NONE cterm=NONE
hi @parameter.reference  guisp=NONE guifg=#9F8D8C guibg=NONE    ctermfg=246 ctermbg=NONE gui=NONE cterm=NONE
hi @number              guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi @float               guisp=NONE guifg=#d16d8a guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi @boolean        guisp=NONE guifg=#b16D8A guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi @constant            guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi @constant.builtin        guisp=NONE guifg=#9B668F guibg=NONE    ctermfg=132 ctermbg=NONE gui=NONE cterm=NONE
hi @constant.macro          guisp=NONE guifg=#B66D8A guibg=NONE    ctermfg=168 ctermbg=NONE gui=NONE cterm=NONE
hi @punctuation.delimiter        guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi @punctuation.bracket            guisp=NONE guifg=#95667C guibg=NONE    ctermfg=96 ctermbg=NONE gui=NONE cterm=NONE
hi @punctuation.special        guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=bold cterm=bold
hi @operator            guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi @conditional         guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=italic cterm=italic
hi @repeat              guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=italic cterm=italic
hi @exception           guisp=NONE guifg=#794966 guibg=NONE    ctermfg=95  ctermbg=NONE gui=NONE cterm=NONE
hi @label               guisp=NONE guifg=#A8899C guibg=NONE    ctermfg=139 ctermbg=NONE gui=NONE cterm=NONE
hi @macro          guisp=NONE guifg=#926C83 guibg=NONE    ctermfg=96 ctermbg=NONE gui=NONE cterm=NONE
hi @todo       guisp=NONE guifg=#c58d5d guibg=NONE    ctermfg=173 ctermbg=NONE  gui=NONE cterm=NONE

hi BufferCurrent       guisp=NONE guifg=NONE  guibg=#3d3339    ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi BufferCurrentIndex  guisp=NONE guifg=NONE  guibg=#3d3339    ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi BufferCurrentMod    guisp=NONE guifg=#d16d8a  guibg=#3d3339 ctermfg=231 ctermbg=237 gui=NONE cterm=NONE
hi BufferCurrentSign   guisp=NONE guifg=NONE  guibg=#3d3339    ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE
hi BufferCurrentTarget guisp=NONE guifg=NONE  guibg=#3d3339    ctermfg=NONE ctermbg=237 gui=NONE cterm=NONE

hi BufferVisible       guisp=NONE guifg=NONE  guibg=NONE    ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi BufferVisibleIndex  guisp=NONE guifg=NONE  guibg=NONE    ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi BufferVisibleMod    guisp=NONE guifg=#d16d8a  guibg=#3d3339 ctermfg=231 ctermbg=237 gui=NONE cterm=NONE
hi BufferVisibleSign   guisp=NONE guifg=NONE  guibg=NONE    ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi BufferVisibleTarget guisp=NONE guifg=NONE  guibg=NONE    ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE

hi Sneak guisp=NONE guifg=NONE  guibg=#43282f ctermfg=NONE ctermbg=236  gui=NONE cterm=NONE
hi SneakScope guisp=NONE guifg=NONE  guibg=#43282f ctermfg=NONE ctermbg=236  gui=NONE cterm=NONE
hi SneakLabel guisp=NONE guifg=NONE  guibg=#43282f ctermfg=NONE ctermbg=236  gui=NONE cterm=NONE
