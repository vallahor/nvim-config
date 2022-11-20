set background=dark
hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='gruvball-ish'
set t_Co=256

hi ColorColumn      guisp=none    guifg=#C0AEA0 guibg=#493441  ctermfg=none ctermbg=95    gui=none cterm=none
hi Conceal          guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi Cursor           guisp=none    guifg=#222022 guibg=#f4ddcc  ctermfg=235  ctermbg=145   gui=none cterm=none
hi iCursor          guisp=none    guifg=none    guibg=#b1314c  ctermfg=none ctermbg=131   gui=none cterm=none
hi lCursor          guisp=none    guifg=none    guibg=#382536  ctermfg=145  ctermbg=none  gui=none cterm=none
hi CursorIM         guisp=none    guifg=none    guibg=#382536  ctermfg=145  ctermbg=none  gui=none cterm=none
hi CursorColumn     guisp=none    guifg=none    guibg=#382536  ctermfg=145  ctermbg=none  gui=none cterm=none
hi CursorLine       guisp=none    guifg=none    guibg=#382536  ctermfg=145  ctermbg=none  gui=none cterm=none
hi Directory        guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi DiffAdd          guisp=none    guifg=#b9e0d3 guibg=#1a563f  ctermfg=231  ctermbg=none  gui=none cterm=none
hi DiffChange       guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi DiffDelete       guisp=none    guifg=#e8b9b8 guibg=#9d2640  ctermfg=231  ctermbg=none  gui=none cterm=none
hi DiffText         guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi EndOfBuffer      guisp=none    guifg=#493441 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi ErrorMsg         guisp=none    guifg=#b1314c guibg=none     ctermfg=231  ctermbg=none  gui=none cterm=none
hi VertSplit        guisp=none    guifg=#382536 guibg=none     ctermfg=231  ctermbg=none  gui=none cterm=none
hi Folded           guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi FoldColumn       guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi SignColumn       guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi IncSearch        guisp=none    guifg=none    guibg=#c64964  ctermfg=231  ctermbg=none  gui=none cterm=none
hi LineNr           guisp=none    guifg=#493441 guibg=none     ctermfg=95   ctermbg=none  gui=none cterm=none
hi LineNrAbove      guisp=none    guifg=#493441 guibg=none     ctermfg=95   ctermbg=none  gui=none cterm=none
hi LineNrBelow      guisp=none    guifg=#493441 guibg=none     ctermfg=95   ctermbg=none  gui=none cterm=none
hi CursorLineNr     guisp=none    guifg=#a1495c guibg=#382536  ctermfg=95   ctermbg=236   gui=none cterm=none
hi MatchParen       guisp=none    guifg=#ff8080 guibg=none     ctermfg=210  ctermbg=none  gui=none cterm=none
" hi MatchParen       guisp=none guifg=#ff8080  guibg=#040004 ctermfg=210 ctermbg=none gui=none cterm=none
hi ModeMsg          guisp=none    guifg=#C0AEA0 guibg=#382536  ctermfg=145  ctermbg=236   gui=none cterm=none
hi MoreMsg          guisp=none    guifg=#C0AEA0 guibg=#382536  ctermfg=145  ctermbg=236   gui=none cterm=none
hi NonText          guisp=none    guifg=none    guibg=none     ctermfg=none ctermbg=none  gui=none cterm=none
hi Pmenu            guisp=none    guifg=#C0AEA0 guibg=#363436  ctermfg=145  ctermbg=237   gui=none cterm=none
hi PmenuSel         guisp=none    guifg=none    guibg=#493441  ctermfg=139  ctermbg=none  gui=none cterm=none
hi PmenuSbar        guisp=none    guifg=#C0AEA0 guibg=#382536  ctermfg=145  ctermbg=236   gui=none cterm=none
hi PmenuThumb       guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi Question         guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi QuickFixLine     guisp=none    guifg=#b1314c guibg=none     ctermfg=131  ctermbg=none  gui=none cterm=none
hi Search           guisp=none    guifg=none    guibg=#43282f  ctermfg=none ctermbg=236   gui=none cterm=none
hi SpecialKey       guisp=none    guifg=#d16d8a guibg=none     ctermfg=231  ctermbg=none  gui=none cterm=none
hi SpellBad         guisp=#a1495c guifg=none    guibg=none     ctermfg=none ctermbg=none  gui=undercurl cterm=underline
hi SpellCap         guisp=#a1495c guifg=none    guibg=none     ctermfg=none ctermbg=none  gui=undercurl cterm=underline
hi SpellLocal       guisp=#a1495c guifg=none    guibg=none     ctermfg=none ctermbg=none  gui=undercurl cterm=underline
hi SpellRare        guisp=#a1495c guifg=none    guibg=none     ctermfg=none ctermbg=none  gui=undercurl cterm=underline
hi StatusLineNC     guisp=none    guifg=none    guibg=#191319  ctermfg=none ctermbg=237   gui=none cterm=none
hi StatusLine       guisp=none    guifg=none    guibg=#291C28  ctermfg=none ctermbg=236   gui=none cterm=none
hi StatusLineTerm   guisp=none    guifg=#C0AEA0 guibg=#382536  ctermfg=145  ctermbg=236   gui=none cterm=none
hi StatusLineTermNC guisp=none    guifg=none    guibg=#363436  ctermfg=none ctermbg=237   gui=none cterm=none
hi TabLine          guisp=none    guifg=none    guibg=#3d3339  ctermfg=none ctermbg=237   gui=none cterm=none
hi TabLineFill      guisp=none    guifg=none    guibg=#222022  ctermfg=none ctermbg=235   gui=none cterm=none
hi TabLineSel       guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi Terminal         guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi Title            guisp=none    guifg=#C0AEA0 guibg=none     ctermfg=145  ctermbg=none  gui=none cterm=none
hi Visual           guisp=none    guifg=none    guibg=#363436  ctermfg=none ctermbg=237   gui=none cterm=none
hi VisualNOS        guisp=none    guifg=none    guibg=#363436  ctermfg=none ctermbg=237   gui=none cterm=none
hi WarningMsg       guisp=none    guifg=#d16d8a guibg=none     ctermfg=231  ctermbg=none  gui=none cterm=none
hi WildMenu         guisp=none    guifg=none    guibg=#493441  ctermfg=139  ctermbg=none  gui=none cterm=none

hi Normal     guisp=none guifg=#A98D92 guibg=#121112 ctermfg=138 ctermbg=235  gui=none cterm=none
hi Comment    guisp=none guifg=#9f8d8c guibg=none    ctermfg=246 ctermbg=none gui=none cterm=none
hi Constant   guisp=none guifg=#A8899C guibg=none    ctermfg=139 ctermbg=none gui=none cterm=none
hi Identifier guisp=none guifg=#A98D92 guibg=#121112 ctermfg=138 ctermbg=235  gui=none cterm=none
hi Statement  guisp=none guifg=#794966 guibg=none    ctermfg=95  ctermbg=none gui=none cterm=none
hi PreProc    guisp=none guifg=#c58d5d guibg=none    ctermfg=173 ctermbg=none gui=bold cterm=bold
hi Type       guisp=none guifg=#806292 guibg=none    ctermfg=96  ctermbg=none gui=none cterm=none
hi Special    guisp=none guifg=#806292 guibg=none    ctermfg=96  ctermbg=none gui=none cterm=none
hi Underlined guisp=none guifg=#C0AEA0 guibg=none    ctermfg=145 ctermbg=none gui=none cterm=none
hi Ignore     guisp=none guifg=#C0AEA0 guibg=none    ctermfg=145 ctermbg=none gui=none cterm=none
hi Error      guisp=none guifg=#b1314c guibg=none    ctermfg=131 ctermbg=none gui=none cterm=none
hi Todo       guisp=none guifg=#c58d5d guibg=none    ctermfg=173 ctermbg=none gui=none cterm=none

hi String      guisp=none guifg=#b16D8A guibg=none ctermfg=132 ctermbg=none gui=none cterm=none
hi Character   guisp=none guifg=#b16D8A guibg=none ctermfg=132 ctermbg=none gui=none cterm=none
hi Number      guisp=none guifg=#d16d8a guibg=none ctermfg=168 ctermbg=none gui=none cterm=none
hi Boolean     guisp=none guifg=#d16d8a guibg=none ctermfg=168 ctermbg=none gui=none cterm=none
hi Float       guisp=none guifg=#d16d8a guibg=none ctermfg=168 ctermbg=none gui=none cterm=none
hi Function    guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=none cterm=none
hi Conditional guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=italic cterm=italic
hi Repeat      guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=italic cterm=italic
hi Label       guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none cterm=none
hi Operator    guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none cterm=none
hi Keyword     guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=none cterm=none
hi Exception   guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none cterm=none
hi Include     guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=none cterm=none
hi Include               guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=none cterm=none
hi Define      guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none cterm=none
hi @define     guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none cterm=none
hi Macro       guisp=none guifg=#926C83 guibg=none ctermfg=96  ctermbg=none gui=none cterm=none

hi PreCondit      guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=bold cterm=bold
hi StorageClass   guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=bold cterm=bold
hi Structure      guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=bold cterm=bold
hi Typedef        guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=bold cterm=bold
hi SpecialChar    guisp=none guifg=#A8899C guibg=none ctermfg=139 ctermbg=none gui=none cterm=none
hi Tag            guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=none cterm=none
hi Delimiter      guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=bold cterm=bold
hi SpecialComment guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none cterm=none
hi Debug          guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none cterm=none

hi gitcommitSummary guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none cterm=none

hi DiagnosticError guisp=none guifg=#794966 guibg=none ctermfg=95 ctermbg=none gui=italic cterm=italic
hi DiagnosticWarn  guisp=none guifg=#794966 guibg=none ctermfg=95 ctermbg=none gui=italic cterm=italic
hi DiagnosticInfo  guisp=none guifg=#794966 guibg=none ctermfg=95 ctermbg=none gui=italic cterm=italic
hi DiagnosticHint  guisp=none guifg=#794966 guibg=none ctermfg=95 ctermbg=none gui=italic cterm=italic

hi DiagnosticUnderlineError guisp=#a1495c guifg=#794966 guibg=none ctermfg=95 ctermbg=none gui=undercurl,bold cterm=underline,bold
hi DiagnosticUnderlineWarn  guisp=#a1495c guifg=#794966 guibg=none ctermfg=95 ctermbg=none gui=undercurl,bold cterm=underline,bold
hi DiagnosticUnderlineInfo  guisp=#a1495c guifg=#794966 guibg=none ctermfg=95 ctermbg=none gui=italic cterm=italic
hi DiagnosticUnderlineHint  guisp=#a1495c guifg=#794966 guibg=none ctermfg=95 ctermbg=none gui=undercurl,bold cterm=underline,bold

" hi @include               guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=none   cterm=none
hi @include               guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=none   cterm=none
hi @character             guisp=none guifg=#b16D8A guibg=none ctermfg=132 ctermbg=none gui=none   cterm=none
hi @string                guisp=none guifg=#b16D8A guibg=none ctermfg=132 ctermbg=none gui=none   cterm=none
hi @string.regex          guisp=none guifg=#b16D8A guibg=none ctermfg=132 ctermbg=none gui=none   cterm=none
hi @string.escape         guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none   cterm=none
hi @string.special        guisp=none guifg=#A8899C guibg=none ctermfg=139 ctermbg=none gui=none   cterm=none
hi @keyword               guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=none   cterm=none
hi @keyword.function      guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=none   cterm=none
hi @keyword.return        guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=italic cterm=italic
hi @keyword.operator      guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none   cterm=none
hi @variable              guisp=none guifg=#A98D92 guibg=none ctermfg=138 ctermbg=none gui=none   cterm=none
hi @variable.builtin      guisp=none guifg=#806292 guibg=none ctermfg=145 ctermbg=none gui=italic cterm=italic
hi @tag                   guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=none   cterm=none
hi @tag.delimiter         guisp=none guifg=#9F8D8C guibg=none ctermfg=246 ctermbg=none gui=none   cterm=none
hi @tag.attribute         guisp=none guifg=#A8899C guibg=none ctermfg=139 ctermbg=none gui=none   cterm=none
hi @attribute             guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=bold,italic cterm=bold,italic
hi @text                  guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none   cterm=none
hi @text.strong           guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none   cterm=none
hi @text.emphasis         guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none   cterm=none
hi @text.underline        guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none   cterm=none
hi @text.uri              guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none   cterm=none
hi @text.title            guisp=none guifg=#C0AEA0 guibg=none ctermfg=145 ctermbg=none gui=none   cterm=none
hi @text.literal          guisp=none guifg=#9f8d8c guibg=none ctermfg=246 ctermbg=none gui=none   cterm=none
hi @namespace             guisp=none guifg=#926C83 guibg=none ctermfg=96  ctermbg=none gui=none   cterm=none
hi @type                  guisp=none guifg=#806292 guibg=none ctermfg=96  ctermbg=none gui=none   cterm=none
hi @type.qualifier        guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=italic cterm=italic
hi @type.definition       guisp=none guifg=#a1495c guibg=none ctermfg=131 ctermbg=none gui=bold   cterm=bold
hi @type.builtin          guisp=none guifg=#806292 guibg=none ctermfg=96  ctermbg=none gui=none   cterm=none
hi @function              guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=none   cterm=none
hi @function.builtin      guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=none   cterm=none
hi @function.macro        guisp=none guifg=#9B668F guibg=none ctermfg=132 ctermbg=none gui=none   cterm=none
hi @method                guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=none   cterm=none
hi @constructor           guisp=none guifg=#806292 guibg=none ctermfg=96  ctermbg=none gui=none   cterm=none
hi @field                 guisp=none guifg=#926C83 guibg=none ctermfg=96  ctermbg=none gui=none   cterm=none
hi @property              guisp=none guifg=#926C83 guibg=none ctermfg=96  ctermbg=none gui=none   cterm=none
hi @parameter             guisp=none guifg=#A98D92 guibg=none ctermfg=138 ctermbg=none gui=none   cterm=none
hi @parameter.reference   guisp=none guifg=#9F8D8C guibg=none ctermfg=246 ctermbg=none gui=none   cterm=none
hi @number                guisp=none guifg=#d16d8a guibg=none ctermfg=168 ctermbg=none gui=none   cterm=none
hi @float                 guisp=none guifg=#d16d8a guibg=none ctermfg=168 ctermbg=none gui=none   cterm=none
hi @boolean               guisp=none guifg=#b16D8A guibg=none ctermfg=132 ctermbg=none gui=none   cterm=none
hi @constant              guisp=none guifg=#A8899C guibg=none ctermfg=139 ctermbg=none gui=none   cterm=none
hi @constant.builtin      guisp=none guifg=#9B668F guibg=none ctermfg=132 ctermbg=none gui=none   cterm=none
hi @constant.macro        guisp=none guifg=#B66D8A guibg=none ctermfg=168 ctermbg=none gui=none   cterm=none
hi @punctuation.delimiter guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none   cterm=none
" hi @punctuation.bracket   guisp=none guifg=#95667C guibg=none ctermfg=96  ctermbg=none gui=none   cterm=none
hi @punctuation.bracket   guisp=none guifg=#B66D8A guibg=none ctermfg=168 ctermbg=none gui=none   cterm=none
hi @punctuation.special   guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=bold   cterm=bold
hi @operator              guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none   cterm=none
hi @conditional           guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=italic cterm=italic
hi @repeat                guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=italic cterm=italic
hi @exception             guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none   cterm=none
hi @label                 guisp=none guifg=#A8899C guibg=none ctermfg=139 ctermbg=none gui=none   cterm=none
hi @macro                 guisp=none guifg=#926C83 guibg=none ctermfg=96  ctermbg=none gui=none   cterm=none
hi @todo                  guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=none   cterm=none
hi @preproc               guisp=none guifg=#c58d5d guibg=none ctermfg=173 ctermbg=none gui=bold   cterm=bold
hi @debug                 guisp=none guifg=#794966 guibg=none ctermfg=95  ctermbg=none gui=none   cterm=none

hi BufferCurrent       guisp=none guifg=none    guibg=#3d3339 ctermfg=none ctermbg=237 gui=none cterm=none
hi BufferCurrentIndex  guisp=none guifg=none    guibg=#3d3339 ctermfg=none ctermbg=237 gui=none cterm=none
hi BufferCurrentMod    guisp=none guifg=#d16d8a guibg=#3d3339 ctermfg=231  ctermbg=237 gui=none cterm=none
hi BufferCurrentSign   guisp=none guifg=none    guibg=#3d3339 ctermfg=none ctermbg=237 gui=none cterm=none
hi BufferCurrentTarget guisp=none guifg=none    guibg=#3d3339 ctermfg=none ctermbg=237 gui=none cterm=none

hi BufferVisible       guisp=none guifg=none    guibg=none    ctermfg=none ctermbg=none gui=none cterm=none
hi BufferVisibleIndex  guisp=none guifg=none    guibg=none    ctermfg=none ctermbg=none gui=none cterm=none
hi BufferVisibleMod    guisp=none guifg=#d16d8a guibg=#3d3339 ctermfg=231  ctermbg=237  gui=none cterm=none
hi BufferVisibleSign   guisp=none guifg=none    guibg=none    ctermfg=none ctermbg=none gui=none cterm=none
hi BufferVisibleTarget guisp=none guifg=none    guibg=none    ctermfg=none ctermbg=none gui=none cterm=none

hi Sneak guisp=none guifg=none  guibg=#43282f ctermfg=none ctermbg=236  gui=none cterm=none
hi SneakScope guisp=none guifg=none  guibg=#43282f ctermfg=none ctermbg=236  gui=none cterm=none
hi SneakLabel guisp=none guifg=none  guibg=#43282f ctermfg=none ctermbg=236  gui=none cterm=none
