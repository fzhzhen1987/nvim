"========
"主题设置
"========
color hybrid_reverse
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
set termguicolors
" hi Normal     ctermbg=NONE guibg=NONE
" hi LineNr     ctermbg=NONE guibg=NONE
" hi SignColumn ctermbg=NONE guibg=NONE
" hi Comment guifg=#5C6370 ctermfg=59
let g:space_vim_italic=1
let g:enable_bold_font=1
let g:enable_italic_font=1
let &t_ut=''
" let g:oceanic_material_transparent_background = 1
" let g:hybrid_transparent_background = 1

"将CocHighlight RedrawDebugComposed绑定到前面组里
highlight link  CocHighlightText Search

hi CursorLine guifg=#81a2be guibg=#002943

hi Cursor guifg=white guibg=#5F875F
hi iCursor guifg=black guibg=Yellow
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10

"设置末尾空格颜色
highlight Whitespace  cterm=standout ctermfg=234 ctermbg=167 gui=standout guifg=#1d1f21 guibg=#cc6666
