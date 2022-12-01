set background=dark
hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='gruvball-ish'
set t_Co=256

hi ColorColumn      guisp=none    guifg=#C0AEA0 guibg=#493441 gui=none
hi Conceal          guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi Cursor           guisp=none    guifg=#222022 guibg=#f4ddcc gui=none
hi iCursor          guisp=none    guifg=none    guibg=#b1314c gui=none
hi lCursor          guisp=none    guifg=none    guibg=#382536 gui=none
hi CursorIM         guisp=none    guifg=none    guibg=#382536 gui=none
hi CursorColumn     guisp=none    guifg=none    guibg=#382536 gui=none
" hi CursorLine       guisp=none    guifg=none    guibg=#382536 gui=none
hi CursorLine       guisp=none    guifg=none    guibg=#291C28 gui=none
hi Directory        guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi DiffAdd          guisp=none    guifg=#b9e0d3 guibg=#1a563f gui=none
hi DiffChange       guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi DiffDelete       guisp=none    guifg=#e8b9b8 guibg=#9d2640 gui=none
hi DiffText         guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi EndOfBuffer      guisp=none    guifg=#493441 guibg=none    gui=none
hi ErrorMsg         guisp=none    guifg=#b1314c guibg=none    gui=none
hi VertSplit        guisp=none    guifg=#382536 guibg=none    gui=none
hi Folded           guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi FoldColumn       guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi SignColumn       guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi IncSearch        guisp=none    guifg=none    guibg=#c64964 gui=none
hi LineNr           guisp=none    guifg=#493441 guibg=none    gui=none
hi LineNrAbove      guisp=none    guifg=#493441 guibg=none    gui=none
hi LineNrBelow      guisp=none    guifg=#493441 guibg=none    gui=none
" hi CursorLineNr     guisp=none    guifg=#a1495c guibg=#382536 gui=none
hi CursorLineNr     guisp=none    guifg=#a1495c guibg=#291C28 gui=none
hi MatchParen       guisp=none    guifg=#ff8080 guibg=none    gui=none
" hi MatchParen       guisp=none guifg=#ff8080  guibg=#040004   gui=none
hi ModeMsg          guisp=none    guifg=#C0AEA0 guibg=#382536 gui=none
hi MoreMsg          guisp=none    guifg=#C0AEA0 guibg=#382536 gui=none
hi NonText          guisp=none    guifg=none    guibg=none    gui=none
hi Pmenu            guisp=none    guifg=#C0AEA0 guibg=#363436 gui=none
hi PmenuSel         guisp=none    guifg=none    guibg=#493441 gui=none
hi PmenuSbar        guisp=none    guifg=#C0AEA0 guibg=#382536 gui=none
hi PmenuThumb       guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi Question         guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi QuickFixLine     guisp=none    guifg=#b1314c guibg=none    gui=none
hi Search           guisp=none    guifg=none    guibg=#43282f gui=none
hi SpecialKey       guisp=none    guifg=#d16d8a guibg=none    gui=none
hi SpellBad         guisp=#a1495c guifg=none    guibg=none    gui=undercurl
hi SpellCap         guisp=#a1495c guifg=none    guibg=none    gui=undercurl
hi SpellLocal       guisp=#a1495c guifg=none    guibg=none    gui=undercurl
hi SpellRare        guisp=#a1495c guifg=none    guibg=none    gui=undercurl
hi StatusLineNC     guisp=none    guifg=none    guibg=#191319 gui=none
" hi StatusLine       guisp=none    guifg=none    guibg=#291C28 gui=none
hi StatusLine       guisp=none    guifg=none    guibg=#382536 gui=none
hi StatusLineTerm   guisp=none    guifg=#C0AEA0 guibg=#382536 gui=none
hi StatusLineTermNC guisp=none    guifg=none    guibg=#363436 gui=none
hi TabLine          guisp=none    guifg=none    guibg=#3d3339 gui=none
hi TabLineFill      guisp=none    guifg=none    guibg=#222022 gui=none
hi TabLineSel       guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi Terminal         guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi Title            guisp=none    guifg=#C0AEA0 guibg=none    gui=none
hi Visual           guisp=none    guifg=none    guibg=#363436 gui=none
hi VisualNOS        guisp=none    guifg=none    guibg=#363436 gui=none
hi WarningMsg       guisp=none    guifg=#d16d8a guibg=none    gui=none
hi WildMenu         guisp=none    guifg=none    guibg=#493441 gui=none

" hi Normal     guisp=NONE guifg=#A98D92 guibg=#222022 gui=NONE
hi Normal     guisp=none guifg=#A98D92 guibg=#121112 gui=none
hi Comment    guisp=none guifg=#9f8d8c guibg=none    gui=none
hi Constant   guisp=none guifg=#A8899C guibg=none    gui=none
hi Identifier guisp=none guifg=#A98D92 guibg=none    gui=none
hi Statement  guisp=none guifg=#794966 guibg=none    gui=none
hi PreProc    guisp=none guifg=#c58d5d guibg=none    gui=none
hi Type       guisp=none guifg=#806292 guibg=none    gui=none
hi Special    guisp=none guifg=#806292 guibg=none    gui=none
hi Underlined guisp=none guifg=#C0AEA0 guibg=none    gui=none
hi Ignore     guisp=none guifg=#C0AEA0 guibg=none    gui=none
hi Error      guisp=none guifg=#b1314c guibg=none    gui=none
hi Todo       guisp=none guifg=#c58d5d guibg=none    gui=none

hi String      guisp=none guifg=#b16D8A guibg=none gui=none
hi Character   guisp=none guifg=#b16D8A guibg=none gui=none
hi Number      guisp=none guifg=#d16d8a guibg=none gui=none
hi Boolean     guisp=none guifg=#d16d8a guibg=none gui=none
hi Float       guisp=none guifg=#d16d8a guibg=none gui=none
hi Function    guisp=none guifg=#c58d5d guibg=none gui=none
hi Conditional guisp=none guifg=#794966 guibg=none gui=italic
hi Repeat      guisp=none guifg=#794966 guibg=none gui=italic
hi Label       guisp=none guifg=#794966 guibg=none gui=none
hi Operator    guisp=none guifg=#794966 guibg=none gui=none
hi Keyword     guisp=none guifg=#a1495c guibg=none gui=none
" hi Exception   guisp=none guifg=#794966 guibg=none gui=none
hi Exception   guisp=none guifg=#96516E guibg=none gui=none
" hi Include     guisp=none guifg=#c58d5d guibg=none gui=none
hi Include     guisp=none guifg=#c58d5d guibg=none gui=bold
hi Define      guisp=none guifg=#C0AEA0 guibg=none gui=none
hi @define     guisp=none guifg=#C0AEA0 guibg=none gui=none
hi Macro       guisp=none guifg=#926C83 guibg=none gui=none

hi PreCondit      guisp=none guifg=#c58d5d guibg=none gui=none
hi StorageClass   guisp=none guifg=#a1495c guibg=none gui=none
hi Structure      guisp=none guifg=#a1495c guibg=none gui=none
hi Typedef        guisp=none guifg=#a1495c guibg=none gui=none
hi SpecialChar    guisp=none guifg=#A8899C guibg=none gui=none
hi Tag            guisp=none guifg=#a1495c guibg=none gui=none
hi Delimiter      guisp=none guifg=#794966 guibg=none gui=none
hi SpecialComment guisp=none guifg=#794966 guibg=none gui=none
hi Debug          guisp=none guifg=#794966 guibg=none gui=none

hi gitcommitSummary guisp=none guifg=#C0AEA0 guibg=none gui=none
"
hi DiagnosticError guisp=none guifg=#794966 guibg=none gui=italic
hi DiagnosticWarn  guisp=none guifg=#794966 guibg=none gui=italic
hi DiagnosticInfo  guisp=none guifg=#794966 guibg=none gui=italic
hi DiagnosticHint  guisp=none guifg=#794966 guibg=none gui=italic

hi DiagnosticUnderlineError guisp=#a1495c guifg=#794966 guibg=none gui=undercurl,bold
hi DiagnosticUnderlineWarn  guisp=#a1495c guifg=#794966 guibg=none gui=undercurl,bold
hi DiagnosticUnderlineInfo  guisp=#a1495c guifg=#794966 guibg=none gui=italic
hi DiagnosticUnderlineHint  guisp=#a1495c guifg=#794966 guibg=none gui=undercurl,bold

" hi @include               guisp=none guifg=#c58d5d guibg=none gui=none
hi @include               guisp=none guifg=#c58d5d guibg=none gui=bold
hi @character             guisp=none guifg=#b16D8A guibg=none gui=none
hi @string                guisp=none guifg=#b16D8A guibg=none gui=none
hi @string.regex          guisp=none guifg=#b16D8A guibg=none gui=none
hi @string.escape         guisp=none guifg=#794966 guibg=none gui=none
hi @string.special        guisp=none guifg=#A8899C guibg=none gui=none
hi @keyword               guisp=none guifg=#a1495c guibg=none gui=none
hi @keyword.function      guisp=none guifg=#a1495c guibg=none gui=italic
hi @keyword.return        guisp=none guifg=#794966 guibg=none gui=italic
hi @keyword.return        guisp=none guifg=#794966 guibg=none gui=none
hi @keyword.operator      guisp=none guifg=#794966 guibg=none gui=none
hi @variable              guisp=none guifg=#A98D92 guibg=none gui=none
" hi @variable.builtin      guisp=none guifg=#806292 guibg=none gui=italic
hi @variable.builtin      guisp=none guifg=#9B668F guibg=none gui=italic
hi @tag                   guisp=none guifg=#a1495c guibg=none gui=none
hi @tag                   guisp=none guifg=#c58d5d guibg=none gui=italic
hi @tag.delimiter         guisp=none guifg=#9F8D8C guibg=none gui=none
hi @tag.attribute         guisp=none guifg=#A8899C guibg=none gui=none
hi @attribute             guisp=none guifg=#794966 guibg=none gui=italic
hi @text                  guisp=none guifg=#C0AEA0 guibg=none gui=none
hi @text.strong           guisp=none guifg=#C0AEA0 guibg=none gui=none
hi @text.emphasis         guisp=none guifg=#C0AEA0 guibg=none gui=none
hi @text.underline        guisp=none guifg=#C0AEA0 guibg=none gui=none
hi @text.uri              guisp=none guifg=#C0AEA0 guibg=none gui=none
hi @text.title            guisp=none guifg=#C0AEA0 guibg=none gui=none
hi @text.literal          guisp=none guifg=#9f8d8c guibg=none gui=none
hi @namespace             guisp=none guifg=#926C83 guibg=none gui=none
hi @type                  guisp=none guifg=#806292 guibg=none gui=none
hi @type.qualifier        guisp=none guifg=#794966 guibg=none gui=italic
hi @type.definition       guisp=none guifg=#a1495c guibg=none gui=none
hi @type.builtin          guisp=none guifg=#806292 guibg=none gui=none
hi @function              guisp=none guifg=#c58d5d guibg=none gui=none
hi @function.builtin      guisp=none guifg=#c58d5d guibg=none gui=none
hi @function.macro        guisp=none guifg=#9B668F guibg=none gui=none
hi @method                guisp=none guifg=#c58d5d guibg=none gui=none
hi @constructor           guisp=none guifg=#806292 guibg=none gui=none
hi @field                 guisp=none guifg=#926C83 guibg=none gui=none
hi @property              guisp=none guifg=#926C83 guibg=none gui=none
hi @parameter             guisp=none guifg=#A98D92 guibg=none gui=none
hi @parameter.reference   guisp=none guifg=#9F8D8C guibg=none gui=none
hi @number                guisp=none guifg=#d16d8a guibg=none gui=none
hi @float                 guisp=none guifg=#d16d8a guibg=none gui=none
hi @boolean               guisp=none guifg=#b16D8A guibg=none gui=none
hi @constant              guisp=none guifg=#A8899C guibg=none gui=none
hi @constant.builtin      guisp=none guifg=#9B668F guibg=none gui=none
" hi @constant.macro        guisp=none guifg=#B66D8A guibg=none gui=none
hi @constant.macro        guisp=none guifg=#c58d5d guibg=none gui=none
hi @punctuation.delimiter guisp=none guifg=#794966 guibg=none gui=none
hi @punctuation.bracket   guisp=none guifg=#95667C guibg=none gui=none
" hi @punctuation.bracket   guisp=none guifg=#B66D8A guibg=none gui=none
hi @punctuation.special   guisp=none guifg=#794966 guibg=none gui=none
hi @operator              guisp=none guifg=#794966 guibg=none gui=none
hi @conditional           guisp=none guifg=#794966 guibg=none gui=italic
hi @repeat                guisp=none guifg=#794966 guibg=none gui=italic
hi @exception             guisp=none guifg=#794966 guibg=none gui=none
hi @exception             guisp=none guifg=#96516E guibg=none gui=none
hi @label                 guisp=none guifg=#A8899C guibg=none gui=none
hi @macro                 guisp=none guifg=#926C83 guibg=none gui=none
hi @todo                  guisp=none guifg=#c58d5d guibg=none gui=none
hi @preproc               guisp=none guifg=#c58d5d guibg=none gui=none
hi @debug                 guisp=none guifg=#794966 guibg=none gui=none
"
hi @storageclass          guisp=none guifg=#a1495c guibg=none gui=italic
hi @storageclass.lifetime guisp=none guifg=#9B668F guibg=none gui=italic

hi @comment    guisp=none guifg=#887878 guibg=none gui=none
" hi @spell      guisp=none guifg=#b16D8A guibg=none gui=none

hi BufferCurrent       guisp=none guifg=none    guibg=#3d3339 gui=none
hi BufferCurrentIndex  guisp=none guifg=none    guibg=#3d3339 gui=none
hi BufferCurrentMod    guisp=none guifg=#d16d8a guibg=#3d3339 gui=none
hi BufferCurrentSign   guisp=none guifg=none    guibg=#3d3339 gui=none
hi BufferCurrentTarget guisp=none guifg=none    guibg=#3d3339 gui=none

hi BufferVisible       guisp=none guifg=none    guibg=none    gui=none
hi BufferVisibleIndex  guisp=none guifg=none    guibg=none    gui=none
hi BufferVisibleMod    guisp=none guifg=#d16d8a guibg=#3d3339 gui=none
hi BufferVisibleSign   guisp=none guifg=none    guibg=none    gui=none
hi BufferVisibleTarget guisp=none guifg=none    guibg=none    gui=none

hi Sneak guisp=none guifg=none  guibg=#43282f gui=none
hi SneakScope guisp=none guifg=none  guibg=#43282f gui=none
hi SneakLabel guisp=none guifg=none  guibg=#43282f gui=none
