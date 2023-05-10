"      ___           ___           ___           ___           ___           ___           ___           ___         ___
"     /__/\         /  /\         /  /\         /__/\         /  /\         /  /\         /  /\         /  /\       /  /\
"    |  |::\       /  /::\       /  /::\        \  \:\       /  /:/_       /  /:/        /  /::\       /  /::\     /  /:/\
"    |  |:|:\     /  /:/\:\     /  /:/\:\        \  \:\     /  /:/ /\     /  /:/        /  /:/\:\     /  /:/\:\   /  /:/ /\
"  __|__|:|\:\   /  /:/  \:\   /  /:/  \:\   _____\__\:\   /  /:/ /::\   /  /:/  ___   /  /:/~/::\   /  /:/~/:/  /  /:/ /:/_
" /__/::::| \:\ /__/:/ \__\:\ /__/:/ \__\:\ /__/::::::::\ /__/:/ /:/\:\ /__/:/  /  /\ /__/:/ /:/\:\ /__/:/ /:/  /__/:/ /:/ /\
" \  \:\~~\__\/ \  \:\ /  /:/ \  \:\ /  /:/ \  \:\~~\~~\/ \  \:\/:/~/:/ \  \:\ /  /:/ \  \:\/:/__\/ \  \:\/:/   \  \:\/:/ /:/
"  \  \:\        \  \:\  /:/   \  \:\  /:/   \  \:\  ~~~   \  \::/ /:/   \  \:\  /:/   \  \::/       \  \::/     \  \::/ /:/
"   \  \:\        \  \:\/:/     \  \:\/:/     \  \:\        \__\/ /:/     \  \:\/:/     \  \:\        \  \:\      \  \:\/:/
"    \  \:\        \  \::/       \  \::/       \  \:\         /__/:/       \  \::/       \  \:\        \  \:\      \  \::/
"     \__\/         \__\/         \__\/         \__\/         \__\/         \__\/         \__\/         \__\/       \__\/
"
" A simple color sheme inspired by xero harrison's blaquemagick (https://github.com/xero/blaquemagick.vim)
"

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="AEHO"

hi Boolean       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Character     cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi ColorColumn   cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=NONE
hi Comment       cterm=NONE  gui=italic  ctermfg=NONE  guifg=#445544 ctermbg=NONE  guibg=NONE
hi Conditional   cterm=NONE  gui=bold  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Constant      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Cursor        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=#ffefce  ctermbg=NONE  guibg=NONE
hi CursorLine    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi CursorLineNr  cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE    guibg=NONE
hi Define        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Delimiter     cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi DiffAdd       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi DiffChange    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi DiffDelete    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi DiffText      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Directory     cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Error         cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=#1c1c1c
hi ErrorMsg      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi FoldColumn    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Folded        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Function      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Identifier    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Include       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi IncSearch     cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=NONE
hi InfoMsg       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi LineNr        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=NONE
hi Macro         cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi NonText       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Normal        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=#000000 ctermbg=NONE   guibg=#ffefce
hi Operator      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Pmenu         cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=#303030
hi PmenuSel      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE    guibg=#5f8787
hi PmenuSbar     cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=#262626
hi PmenuThumb    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=#444444
hi PreProc       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Search        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE    guibg=#9f8d8c
hi Special       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi SignColumn    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi SpecialKey    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi SpellBad      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi SpellCap      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi SpellLocal    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi SpellRare     cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Statement     cterm=NONE  gui=bold  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi StatusLine    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=#a03343
hi StatusLineNC  cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=#A45159
hi WinBar        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=#a03343
hi WinBarNC      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=#A45159
hi String        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=#a23343  ctermbg=NONE  guibg=NONE
hi TabLine       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi TabLineFill   cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=NONE
hi TabLineSel    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Tag           cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Todo          cterm=NONE  gui=NONE  ctermfg=NONE  guifg=red  ctermbg=NONE    guibg=NONE
hi Type          cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi TypeDef       cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Underlined    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi VertSplit     cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi Visual        cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE   guibg=#a03343
hi WarningMsg    cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi WildMenu      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi WildMenu      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=NONE  ctermbg=NONE  guibg=NONE
hi MatchParen      cterm=NONE  gui=NONE  ctermfg=NONE  guifg=red  ctermbg=NONE  guibg=NONE
