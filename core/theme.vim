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

"设置dominikduda/vim_current_word的同单词颜色
highlight CurrentWordTwins guifg=white guibg=blue gui=italic ctermfg=white ctermbg=blue cterm=italic

hi DiffAdded guifg=green ctermfg=3
hi! link DiffChange		wildMenu
hi! link DiffAdd		DiffAdded
hi! link DiffDelete		DiagnosticError


"==== vim-lsp-cxx-highlight C 语言语义高亮配置 ====
" 最重要：未激活的预处理器代码（ifdef 未启用的代码变灰）
highlight LspCxxHlGroupInactiveCode guifg=#4a4a4a ctermfg=240 gui=italic
highlight link LspCxxHlSkippedRegion LspCxxHlGroupInactiveCode
highlight link LspCxxHlSkippedRegionBeginEnd LspCxxHlGroupInactiveCode

" C 语言核心元素
" 预处理器指令（#include, #define, #ifdef 等）
highlight LspCxxHlSymPreprocessor guifg=#c678dd ctermfg=176 gui=bold

" 宏定义和宏调用
highlight LspCxxHlSymMacro guifg=#d19a66 ctermfg=173 gui=bold
highlight LspCxxHlGroupMacroExpansion guifg=#d19a66 ctermfg=173

" 枚举常量
highlight LspCxxHlGroupEnumConstant guifg=#d19a66 ctermfg=173

" 全局变量
highlight LspCxxHlSymVariable guifg=#e06c75 ctermfg=168

" 函数参数
highlight LspCxxHlSymParameter guifg=#e5c07b ctermfg=180

" 静态函数和变量
highlight LspCxxHlSymStaticMethod guifg=#61afef ctermfg=75 gui=italic
highlight LspCxxHlSymStaticField guifg=#e06c75 ctermfg=168 gui=italic

" 函数声明和定义
highlight LspCxxHlSymFunction guifg=#61afef ctermfg=75

" 结构体和联合体
highlight LspCxxHlSymStruct guifg=#e5c07b ctermfg=180
highlight LspCxxHlSymUnion guifg=#e5c07b ctermfg=180

" typedef 类型别名
highlight LspCxxHlSymTypeAlias guifg=#e5c07b ctermfg=180 gui=italic

" 字段访问（结构体成员）
highlight LspCxxHlSymField guifg=#e06c75 ctermfg=168

" 标签（goto 标签）
highlight LspCxxHlSymLabel guifg=#c678dd ctermfg=176

