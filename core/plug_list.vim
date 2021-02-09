"========
"插件安装
"========
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

call plug#begin('~/.config/nvim/plugged')
"在这里添加插件

"代码开发,动态更新gtags,ale检查错误,显示函数参数
"Plug 'ludovicchabant/vim-gutentags'
"Plug 'w0rp/ale'
Plug 'mbbill/echofunc'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

"美化插件
Plug 'glepnir/galaxyline.nvim'
Plug 'bagrat/vim-buffet'
Plug 'ryanoasis/vim-devicons'
Plug 'hardcoreplayers/dashboard-nvim'
Plug 'nathanaelkane/vim-indent-guides'

"主题插件
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'hardcoreplayers/oceanic-material'
Plug 'mhartington/oceanic-next'

"功能插件
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'junegunn/vim-easy-align', {'on':'<Plug>(EasyAlign)'}
Plug 'voldikss/vim-translator', { 'on':'<Plug>Translate' }
Plug 'kien/rainbow_parentheses.vim'
Plug 'chrisbra/changesPlugin'
Plug 'neoclide/coc.nvim',{'branch':'release'}

Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'
Plug 'gcmt/wildfire.vim'
Plug 'liuchengxu/vim-which-key'

Plug 'airblade/vim-gitgutter'

"ranger插件
Plug 'kevinhwang91/rnvimr', {'on': 'RnvimrToggle'}
"fzf相关
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim',

"置显示当前文件的函数和变量list
Plug 'liuchengxu/vista.vim', {'on':'Vista'}

"代码注释,需要研究
Plug 'scrooloose/nerdcommenter'

"可能要删除,neoformat需要调整
Plug 'sbdchd/neoformat', {'on':'Neoformat'}

"高亮多个单词
Plug 'lfv89/vim-interestingwords'

"nvim下使用tig
Plug 'iberianpig/tig-explorer.vim'
Plug 'rbgrouleff/bclose.vim'

"markdown专用,暂时不装
"Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
"Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

"Plug 'tyru/open-browser.vim', {'on':['<Plug>(openbrowser-smart-search)', '<Plug>(openbrowser-open)']}
call plug#end()


"airblade/vim-gitgutter
" let g:gitgutter_signs = 0
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '░'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▒'
" autocmd BufWritePost * GitGutter
"nnoremap <LEADER>gf :GitGutterFold<CR>
nnoremap h :GitGutterPreviewHunk<CR>
nnoremap <LEADER>gp :GitGutterPrevHunk<CR>
nnoremap <LEADER>gn :GitGutterNextHunk<CR>
nnoremap <LEADER>gl :GitGutterLineHighlightsToggle<CR>

"lazygit,tig
noremap <LEADER>gg :tabe<CR>:-tabmove<CR>:term lazygit<CR>

"noremap <LEADER>gt :tabe<CR>:-tabmove<CR>:term tig<CR>
nnoremap <Leader>gt :TigOpenProjectRootDir<CR>
nnoremap <Leader>gT :TigOpenCurrentFile<CR>
nnoremap <Leader>gb :TigBlame<CR>
nnoremap <Leader>gf :<C-u>:TigGrep<Space><C-R><C-W><CR>

"=============代码开发所需要的工具配置===========
" ===========gutentags=============
" 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
"let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project', '.gitignore']

"判断是否是linux kernel目录,若是ctags查找的目录为find_list
"if isdirectory("kernel/") && isdirectory("mm/")
"	let g:gutentags_file_list_command = 'find arch/arm/ mm/ kernel/ include/ init/ lib/'
"endif

" 添加ctags额外参数，会让tags文件变大
" let g:gutentags_ctags_extra_args = ['--fields=+lS']
" let g:gutentags_ctags_extra_args = ['--fields=+niazlS', '--extra=+q']
" let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" ======ALE静态语法检测========
"let g:ale_sign_column_always = 1
"let g:ale_sign_error = '✗'
"let g:ale_sign_warning = 'w'
"let g:ale_statusline_format = ['✗ %d', '⚡ %d', '✔ OK']
"let g:ale_echo_msg_format = '[%linter%] %code: %%s'
"let g:ale_lint_on_text_changed = 'normal'
"let g:ale_lint_on_insert_leave = 1
""let g:airline#extensions#ale#enabled = 1
"let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
"let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
"let g:ale_c_cppcheck_options = ''
"let g:ale_cpp_cppcheck_options = ''

" global:建立数据库
"if filereadable("GTAGS")
"	set cscopetag
"	set cscopeprg=gtags-cscope
"	cs add GTAGS
"	au BufWritePost *.c,*.cpp,*.h silent! !global -u &
"endif

"  自动加载ctags: ctags -R
"if filereadable("tags")
"	set tags=tags
"endif

"============
"功能插件设置
"============
"COC设置
source ~/.config/nvim/core/coc_config.vim

"liuchengxu/vista.vim设置
noremap <LEADER>dl :Vista coc<CR>
let g:vista#renderer#enable_icon = 1
let g:vista_disable_statusline = 1
"let g:vista_default_executive = 'ctags'
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_executive_for = {
			\ 'c': 'coc',
			\ }

"voldikss/vim-translator设置
nmap <silent> <Leader>ts <Plug>TranslateW
vmap <silent> <Leader>ts <Plug>TranslateWV
let g:translator_window_max_width=0.3
let g:translator_window_max_height=0.3
let g:translator_default_engines=['youdao' , 'google']

"Nsbdchd/neoformat设置
" nnoremap <LEADER>fm :Neoformat<CR>

"FZF模糊搜索设置
let g:fzf_action = {
  \ 'alt-h': 'split',
  \ 'alt-v': 'vsplit' }

nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fh :History<CR>
nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fg :GFiles<CR>
nnoremap <silent> <Leader>tc :Colors<CR>
nnoremap <silent> <Leader>rg :RG <C-r><C-w><CR>
nnoremap <Leader>fa :Ag <C-r><C-w>
nnoremap <Leader>fr :Rg <C-r><C-w>
nnoremap <silent> <Leader>fm :Marks<CR>

noremap <LEADER>fn :DashboardNewFile<CR>

let g:fzf_preview_window = 'down:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

"command! -bang -nargs=? -complete=dir Files
"    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']}, <bang>0)

function! s:list_buffers()
	redir => list
	silent ls
	redir END
	return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
	execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

"Rg,可以使用内容和文件名筛选
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --color=always --line-number --no-heading -g !.git  --smart-case -w -F '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

"Ag
command! -bang -nargs=* Ag
  \ call fzf#vim#grep(
  \   'ag --color --smart-case -Q -w --ignore .git  '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

"command RG,搜索内容要连贯.
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --hidden --line-number --no-heading --color=always -g !.gitignore -g !.git --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
""""""""""""""""""""""""""""""""""""""""""""""
"关闭buffer
command! BD call fzf#run(fzf#wrap({
			\ 'source': s:list_buffers(),
			\ 'sink*': { lines -> s:delete_buffers(lines) },
			\ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
			\ }))

"关闭当前buffer
noremap <S-Tab> :Bw<CR>
nnoremap <silent> <Leader>fd :BD<CR>
"""""""""""""""""""""""""""""""""""""""""""""""

"nathanaelkane/vim-indent-guides设置
let g:indent_guides_default_mapping = 0
nmap <nop> <Plug>IndentGuidesToggle

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=green ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=black ctermbg=4
let g:indent_guides_color_change_percent = 5
let g:indent_guide_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_space_guides = 0

" Rainbow_Parenthess设置
let g:rbpt_colorpairs = [
			\ ['brown',       'RoyalBlue3'],
			\ ['Darkblue',    'SeaGreen3'],
			\ ['darkgray',    'DarkOrchid3'],
			\ ['darkgreen',   'firebrick3'],
			\ ['darkcyan',    'RoyalBlue3'],
			\ ['darkred',     'SeaGreen3'],
			\ ['darkmagenta', 'DarkOrchid3'],
			\ ['brown',       'firebrick3'],
			\ ['gray',        'RoyalBlue3'],
			\ ['black',       'SeaGreen3'],
			\ ['darkmagenta', 'DarkOrchid3'],
			\ ['Darkblue',    'firebrick3'],
			\ ['darkgreen',   'RoyalBlue3'],
			\ ['darkcyan',    'SeaGreen3'],
			\ ['darkred',     'DarkOrchid3'],
			\ ['red',         'firebrick3'],
			\ ]
let g:rbpt_max = 16
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"NerdCommenter设置
let g:NERDSpaceDelims            = 1
let g:NERDCompactSexyComs        = 1
let g:NERDDefaultAlign           = 'left'
let g:NERDAltDelims_java         = 1
let g:NERDCustomDelimiters       = {'c': {'left': '/*', 'right': '*/'}}
let g:NERDCommentEmptyLines      = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines    = 1

"vim-visual-multi按键修改
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

"Undotree
noremap <C-r> :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_DiffAutoOpen = 0
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_SplitWidth = 24
function g:Undotree_CustomMap()
nmap <buffer> <C-p> <plug>UndotreeNextState
nmap <buffer> <C-n> <plug>UndotreePreviousState
endfunc

"liuchengxu/vim-which-key
let g:mapleader = "\<Space>"
let g:maplocalleader = ","
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :WhichKey ','<CR>

"============
"美化插件设置
"============

"Dashboard设置
" let g:dashboard_custom_header = [
"       \ '',
"       \ '███████╗██╗   ██╗ ██████╗ ██╗    ██╗   ██╗███████╗    ██╗',
"       \ '██╔════╝██║   ██║██╔═══██╗██║    ██║   ██║██╔════╝    ██║',
"       \ '█████╗  ██║   ██║██║   ██║██║    ██║   ██║█████╗      ██║',
"       \ '██╔══╝  ╚██╗ ██╔╝██║   ██║██║    ╚██╗ ██╔╝██╔══╝      ╚═╝',
"       \ '███████╗ ╚████╔╝ ╚██████╔╝███████╗╚████╔╝ ███████╗    ██╗',
"       \ '╚══════╝  ╚═══╝   ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝    ╚═╝',
"       \ '',
"       \ '                       [KyleJKC]',
"       \ '',
"       \ ]
let g:dashboard_custom_shortcut={
			\ 'last_session'       : 'SPC s l',
			\ 'find_history'       : 'SPC f h',
			\ 'find_file'          : 'SPC f f',
			\ 'new_file'           : 'SPC f n',
			\ 'change_colorscheme' : 'SPC t c',
			\ 'find_word'          : 'SPC f a',
			\ 'book_marks'         : 'SPC f b',
			\ }

"Galaxyline设置
luafile ~/.config/nvim/theme/eviline.lua

"vim-easy-align设置
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"Vim-buffet设置
let g:buffet_show_index = 1
nmap <leader>1 <Plug>BuffetSwitch(1)
nmap <leader>2 <Plug>BuffetSwitch(2)
nmap <leader>3 <Plug>BuffetSwitch(3)
nmap <leader>4 <Plug>BuffetSwitch(4)
nmap <leader>5 <Plug>BuffetSwitch(5)
nmap <leader>6 <Plug>BuffetSwitch(6)
nmap <leader>7 <Plug>BuffetSwitch(7)
nmap <leader>8 <Plug>BuffetSwitch(8)
nmap <leader>9 <Plug>BuffetSwitch(9)
nmap <leader>0 <Plug>BuffetSwitch(10)


""""""""""""""""""""自制jump-motion"""""""""""""""
"CTRL-o,CTRL-i系统不可修改键位,重新映射到<A-,>,<A-.>
"映射<C-o>,<C-i>不能清空
"map <C-o> <nop>
"map <C-i> <nop>
"
"function! FzhGotoJump()
"  jumps
"  let j = input("Please select your jump: ")
"  if j != ''
"    let pattern = '\v\c^\+'
"    if j =~ pattern
"      let j = substitute(j, pattern, '', 'g')
"      execute "normal " . j . "\<c-i>"
"    else
"      execute "normal " . j . "\<c-o>"
"    endif
"  endif
"endfunction

function! FzhGotoJump_prev()
      execute "normal " . 1 . "\<c-o>"
endfunction
function! FzhGotoJump_next()
      execute "normal " . 1 . "\<c-i>"
endfunction

nnoremap <A-,> :call FzhGotoJump_prev()<CR>
nnoremap <A-.> :call FzhGotoJump_next()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Yggdroot/LeaderF
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
"let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

"修改键位
let g:Lf_CommandMap = {'<C-P>': ['<C-E>'], '<C-K>': ['<C-P>'], '<C-J>': ['<C-N>'], '<ESC>': ['<C-Q>', '<ESC>'], '<C-UP>': ['<C-K>'], '<C-DOWN>': ['<C-J>'], '<C-X>': ['<C-H>'], '<C-]>': ['<C-V>']}

"let g:Lf_ShortcutF = '<leader>lf'
let g:Lf_ShortcutF = '<nop>'
let g:Lf_ShortcutB = '<nop>'
"选中后查找
xnoremap / :<C-U><C-R>=printf("Leaderf! rg --current-buffer -F -e %s ", leaderf#Rg#visual())<CR><CR>
noremap <leader>ll :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
noremap <leader>lh :<C-U>Leaderf! rg --recall<CR>
noremap <leader>lm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>

noremap <leader>lf :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>
noremap <leader>lt :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>

"lfv89/vim-interestingwords
let g:interestingWordsDefaultMappings = 0
nnoremap <silent> <leader>m :call InterestingWords('n')<cr>
vnoremap <silent> <leader>m :call InterestingWords('v')<cr>
nnoremap <silent> <leader>M :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation(1)<cr>
nnoremap <silent> N :call WordNavigation(0)<cr>
