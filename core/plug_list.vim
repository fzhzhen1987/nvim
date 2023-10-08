"========
"插件安装
"========
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

if ($OS == 'Windows_NT')
	call plug#begin('~/AppData/Local/nvim/plugged')
else
	call plug#begin('~/.config/nvim/plugged')
endif
"在这里添加插件

"自动匹配符号
Plug 'jiangmiao/auto-pairs'

"符号包裹插件
Plug 'tpope/vim-surround'

"undotree
"Plug 'mbbill/undotree'

"关闭buffer
Plug 'moll/vim-bbye'

"高亮多个单词
Plug 'lfv89/vim-interestingwords'
Plug 'dominikduda/vim_current_word'

"lf插件
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'

"ranger插件
Plug 'kevinhwang91/rnvimr', {'on': 'RnvimrToggle'}
"fzf相关
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'

"文件中显示git修改
Plug 'airblade/vim-gitgutter'

"tab缩进
Plug 'nathanaelkane/vim-indent-guides'

"多光标编辑
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

"显示当前文件行修改处高亮
Plug 'chrisbra/changesPlugin'

"Markdown对齐,使用时候需要具体查
Plug 'preservim/vim-markdown'
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align', {'on':'<Plug>(EasyAlign)'}
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle', 'for': ['text', 'markdown', 'vim-plug'] }

"主题
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'hardcoreplayers/oceanic-material'
Plug 'mhartington/oceanic-next'

"LSP C 语义高亮（支持 ifdef 变灰）
Plug 'jackguo380/vim-lsp-cxx-highlight'

"代码分析
Plug 'ludovicchabant/vim-gutentags'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

"copilot
" Plug 'github/copilot.vim'
" Plug 'Exafunction/codeium.vim', { 'branch': 'main' }

call plug#end()

"===================插件配置开始=====================
"jiangmiao/auto-pairs
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert= ''
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"'}
let g:AutoPairs['<']='>'
let g:AutoPairsMapCh = 0
let g:AutoPairsFlyMode = 0
let g:AutoPairsMultilineClose=0


"tpope/vim-surround
let g:surround_no_mappings = 1
nmap js <Plug>Dsurround
nmap cs <Plug>Csurround
xmap S  <Plug>VSurround
nmap ys <Plug>Ysurround


"github/copilot.vim"
" let g:copilot_no_tab_map = v:true
" imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:codeium_disable_bindings = 1
imap <script><silent><nowait><expr> <C-j> codeium#Accept()
imap <A-j>   <Cmd>call codeium#CycleCompletions(1)<CR>
imap <A-k>   <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-g>   <Cmd>call codeium#Clear()<CR>

"Undotree
" noremap <C-r> :UndotreeToggle<CR>
" let g:undotree_DiffAutoOpen = 1
" let g:undotree_SetFocusWhenToggle = 1
" let g:undotree_DiffAutoOpen = 1
" let g:undotree_ShortIndicators = 1
" let g:undotree_WindowLayout = 2
" let g:undotree_SplitWidth = 24
" function g:Undotree_CustomMap()
" nmap <buffer> <C-p> <plug>UndotreeNextState
" nmap <buffer> <C-n> <plug>UndotreePreviousState
" endfunc


"moll/vim-bbye
"关闭当前buffer
noremap <S-Tab> :Bw<CR>


"lfv89/vim-interestingwords
let g:interestingWordsGUIColors = ['#FF4500', '#FF8C00', '#FFD700', '#00FF00', '#00FFFF', '#1E90FF', '#8A2BE2', '#FF00FF', '#F2F2F2', '#aeee00', '#ff0000', '#56C38D', '#ABABAB', '#b88823', '#ffa724', '#8CCBEA', '#A4E57E', '#FFDB72', '#FF7272', '#FFB3FF', '#9999FF']

let g:interestingWordsDefaultMappings = 0
nnoremap <silent> <leader>m :call InterestingWords('n')<cr>
vnoremap <silent> <leader>m :call InterestingWords('v')<cr>
nnoremap <silent> <leader>M :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation(1)<cr>
nnoremap <silent> N :call WordNavigation(0)<cr>


"dominikduda/vim_current_word
"highlight_twins的颜色配置在theme.vim
"Twins of word under cursor:
let g:vim_current_word#highlight_twins = 1
"The word under cursor:
let g:vim_current_word#highlight_current_word = 1


"lazygit启动
noremap <LEADER>gg :tabe<CR>:-tabmove<CR>:term lazygit<CR>


"FZF模糊搜索设置
"let g:fzf_preview_window = 'down:60%'
"let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
"
"let g:fzf_action = {
"  \ 'ctrl-o': 'split',
"  \ 'ctrl-e': 'vsplit' }

"nnoremap <silent> <Leader>fh :History<CR>
"nnoremap <silent> <Leader>ff :Files<CR>
"nnoremap <silent> <Leader>fg :GFiles<CR>
"nnoremap <silent> <Leader>tc :Colors<CR>
"nnoremap <silent> <Leader>rg :RG <C-r><C-w><CR>
"nnoremap <Leader>fa :Ag <C-r><C-w>
"nnoremap <Leader>fr :Rg <C-r><C-w>
"nnoremap <silent> <Leader>fm :Marks<CR>

"fr,可以使用内容和文件名筛选
"command! -bang -nargs=* Rg
"  \ call fzf#vim#grep(
"  \   'rg --color=always --line-number --no-heading -g !.git  --smart-case -w -F '.shellescape(<q-args>), 1,
"  \   fzf#vim#with_preview(), <bang>0)
"
""fa
"command! -bang -nargs=* Ag
"  \ call fzf#vim#grep(
"  \   'rg --color=always --line-number --no-heading -g !.git  --smart-case -F '.shellescape(<q-args>), 1,
"  \   fzf#vim#with_preview(), <bang>0)
"
""Ag
""command! -bang -nargs=* Ag
""  \ call fzf#vim#grep(
""  \   'ag --color --smart-case -Q --ignore .git  '.shellescape(<q-args>), 1,
""  \   fzf#vim#with_preview(), <bang>0)
"
""command RG,搜索内容要连贯.
"function! RipgrepFzf(query, fullscreen)
"  let command_fmt = 'rg --column --hidden --line-number --no-heading --color=always -g !.gitignore -g !.git --smart-case -- %s || true'
"  let initial_command = printf(command_fmt, shellescape(a:query))
"  let reload_command = printf(command_fmt, '{q}')
"  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
"  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
"endfunction
"
"command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

"airblade/vim-gitgutter
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '░'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▒'


"jackguo380/vim-lsp-cxx-highlight
let g:lsp_cxx_hl_use_text_props = 1

" 语法高亮优先级（确保 LSP 高亮覆盖默认语法高亮）
let g:lsp_cxx_hl_syntax_priority = 100


"nathanaelkane/vim-indent-guides设置
let g:indent_guides_default_mapping = 0
nmap <nop> <Plug>IndentGuidesToggle

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=green ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=purple ctermbg=4
let g:indent_guides_color_change_percent = 5
let g:indent_guide_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_space_guides = 0


"mg979/vim-visual-multi
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-k>'
let g:VM_maps['Find Subword Under'] = '<C-k>'
let g:VM_maps['Goto Next']          = '<C-n>'
let g:VM_maps['Goto Prev']          = '<C-p>'
let g:VM_maps['Find Next']          = ''
let g:VM_maps['Find Prev']          = ''
let g:VM_maps['Seek Next']          = ''
let g:VM_maps['Seek Prev']          = '' 
let g:VM_maps['Remove Region']      = 'q'
let g:VM_maps['Skip Region']        = ''
let g:VM_maps["Undo"]               = 'u'
let g:VM_maps["Redo"]               = '<C-r>'


"chrisbra/changesPlugin [h  ]h
let g:changes_autocmd=1
let g:changes_use_icons = 1
let g:changes_linehi_diff = 0
let g:changes_diff_preview = 0
hi ChangesSignTextAdd ctermbg=yellow ctermfg=black guibg=green
hi ChangesSignTextDel ctermbg=white  ctermfg=black guibg=red
hi ChangesSignTextCh  ctermbg=black  ctermfg=white guibg=blue
hi ChangesSignTextDummyCh  ctermfg=NONE ctermbg=white guifg=NONE guibg=white
hi ChangesSignTextDummyAdd ctermfg=NONE ctermbg=green guifg=NONE guibg=green


"junegunn/vim-easy-align
"1.可视模式选中 2.<leader>ma 3输入 数字+对齐符号
xmap <leader>ma <Plug>(EasyAlign)
nmap <leader>ma <Plug>(EasyAlign)

"dhruvasagar/vim-table-mode
"1.开启toggle 2.开始编辑
nmap <leader>mm :TableModeToggle<cr>

nmap <leader>mt :TableFormat<cr>

"godlygeek/tabular
"1.选中或者不选中执行命令 2.输入分隔符
nmap <leader>mf :Tabu /
xmap <leader>mf :Tabu /

"主题


"====================代码分析===========================
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = expand('~/.gtags.conf')
let g:Lf_Gtagsconf = expand('~/.gtags.conf')

let g:gutentags_define_advanced_commands = 1
"搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.stop_gun', '.root', '.svn', '.git', '.hg', '.project']

"同时开启 ctags 和 gtags 支持：
let g:gutentags_modules = []
if executable('gtags-cscope') && executable('gtags')
	let g:gutentags_modules += ['gtags_cscope']
endif

"检测 ~/.cache/tags 不存在就新建
"将自动生成的tags文件全部放入~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:Lf_CacheDirectory = s:vim_tags
let g:gutentags_cache_dir = expand(g:Lf_CacheDirectory.'/LeaderF/gtags')

if !isdirectory(s:vim_tags)
	silent! call mkdir(s:vim_tags, 'p')
endif

"禁用gutentgs自动加载gtags数据库的行为
let g:gutentags_auto_add_gtags_cscope = 0

"Yggdroot/LeaderF
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1

let g:Lf_GtagsAutoGenerate = 0
let g:Lf_GtagsGutentags = 1
let g:Lf_RootMarkers = ['.stop_gun', '.root', '.svn', '.git', '.hg', '.project']

let g:Lf_WindowPosition = 'right'
let g:Lf_PreviewInPopup = 1
let g:Lf_PreviewHorizontalPosition = 'right'
let g:Lf_JumpToExistingWindow = 0
let g:Lf_PopupWidth = 0.8
let g:Lf_PopupHeight = 0.6
let g:Lf_PreviewCode = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_DefaultMode = 'Regex'

"noremap <C-u> :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <silent> <A-.> :<C-U><C-R>=printf("Leaderf gtags -d %s --top --auto-preview", expand("<cword>"))<CR><CR>
noremap <silent> <A-,> :<C-U><C-R>=printf("Leaderf gtags -r %s --top --auto-preview", expand("<cword>"))<CR><CR>
noremap <silent> <A-p> :<C-U><C-R>=printf("Leaderf gtags --recall %s --top --auto-preview", "")<CR><CR>
"noremap <silent> <leader>js :<C-U><C-R>=printf("Leaderf gtags -s %s --top --auto-preview", expand("<cword>"))<CR><CR>
"noremap <silent> <leader>jf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
"noremap <silent> <leader>ji :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>

":lua print(vim.fn.printf("Leaderf gtags -s %s --top --auto-preview", vim.fn.expand('<cword>')))

"查找当前光标所在单词,C-r打开预览,C-j/k预览翻页,C-e|C-o分屏
"noremap <silent> <leader>jh :<C-U><C-R>=printf("Leaderf mru %s --stayOpen", "")<CR><CR>
"noremap <silent> <leader>jl :<C-U><C-R>=printf("Leaderf line %s --no-sort --stayOpen", "")<CR><CR>

noremap <silent> <A-/> :<C-U><C-R>=printf("Leaderf rg --current-buffer -F -e %s --no-sort --no-auto-preview --preview-position cursor", expand("<cword>"))<CR><CR>
"vmap <silent> fa :<C-U><C-R>=printf("Leaderf rg -F -e %s --no-sort --stayOpen", leaderf#Rg#visual())<CR><CR>
"vmap <silent> fr :<C-U><C-R>=printf("Leaderf rg -F -w -e %s --no-sort --stayOpen", leaderf#Rg#visual())<CR><CR>
"noremap <silent> fa :<C-U><C-R>=printf("Leaderf rg -F -e %s --no-sort --stayOpen", expand("<cword>"))<CR><CR>
"noremap <silent> fr :<C-U><C-R>=printf("Leaderf rg -F -w -e %s --no-sort --stayOpen", expand("<cword>"))<CR><CR>

"修改键位
let g:Lf_CommandMap = {
			\'<C-P>': ['<C-R>'],
			\'<C-K>': ['<C-P>'],
			\'<C-J>': ['<C-N>'],
			\'<ESC>': ['<C-Q>', '<ESC>'],
			\'<C-UP>': ['<C-K>'],
			\'<C-DOWN>': ['<C-J>'],
			\'<C-X>': ['<C-O>'],
			\'<C-]>': ['<C-E>'],
			\'<Home>': ['<C-A>'],
			\'<Right>': ['<C-F>'],
			\'<Left>': ['<C-B>'],
			\}

"let g:Lf_ShortcutF = '<leader>lf'
let g:Lf_ShortcutF = '<nop>'
let g:Lf_ShortcutB = '<nop>'

"ranger
" noremap <LEADER>ra :RnvimrToggle<CR>

"lf插件
let g:lf_map_keys = 0
noremap <LEADER>ra :Lf<CR>
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9

"加载lua配置文件
lua require('FZH_lua')
