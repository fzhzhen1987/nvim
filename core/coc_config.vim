"COC配置文件

let g:coc_status_error_sign = '•'
let g:coc_status_warning_sign = '•'
let g:coc_global_extensions = [
			\ 'coc-marketplace',
			\ 'coc-vimlsp',
			\ 'coc-explorer',
			\ 'coc-pairs',
			\ 'coc-tabnine',
			\ 'coc-python',
			\ 'coc-lists',
			\ 'coc-actions',
			\ 'coc-db',
			\ 'coc-json',
			\ 'coc-highlight',
			\ 'coc-diagnostic',
			\ 'coc-yank']


			" \ 'coc-gitignore',coc-settings.json都没有设置
			" \ 'coc-go',
			" \ 'coc-snippets',		#不会用
			" \ 'coc-spell-checker',
			" \ 'coc-highlight',

"候补项tab补全
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
""""""""""""""""""""""""""""""""""""""
"补全内容回车不跳到下一行
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)


" Use 空格h to show documentation in preview window.文档在弹窗里显示
nnoremap <silent> <leader>h :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

"跳转到代码错误
nmap <silent> <leader>d. <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>d, <Plug>(coc-diagnostic-next)

" Remap for do codeAction of selected region
"function! s:cocActionsOpenFromSelected(type) abort
"  execute 'CocCommand actions.open ' . a:type
"endfunction
"xmap <silent> <leader>l :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
"nmap <silent> <leader>l :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@ 

" grep word under cursor
command! -nargs=+ -complete=custom,s:GrepArgs Rg exe 'CocList grep '.<q-args>

function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction


" 光标所在处高亮
autocmd CursorHold * silent call CocActionAsync('highlight')

"主动调出候选菜单
inoremap <silent><expr> <C-g> coc#refresh()

" coc-explorer
nmap <LEADER>e :CocCommand explorer<CR>
" coc-translator
nmap ts <Plug>(coc-translator-p)

"nnoremap <silent> <A-.>  :<C-u>CocNext<CR>
"nnoremap <silent> <A-,>  :<C-u>CocPrev<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"分屏
map <LEADER>wd :set splitright<CR>:vsplit<CR>
map <LEADER>wa :set nosplitright<CR>:vsplit<CR>
map <LEADER>ww :set nosplitbelow<CR>:split<CR>
map <LEADER>ws :set splitbelow<CR>:split<CR>
"新窗口
map <LEADER>wn :new <CR>
"焦点变换
map <A-d> <C-w>l
map <A-w> <C-w>k
map <A-a> <C-w>h
map <A-s> <C-w>j

map <up> :res +1<CR>
map <down> :res -1<CR>
map <left> :vertical resize-1<CR>
map <right> :vertical resize+1<CR>

"上下变为左右,左右变上下
"map k <C-w>t<C-w>H
"map l <C-w>t<C-w>K
map <LEADER>wv <C-w>t<C-w>H
map <LEADER>wh <C-w>t<C-w>K

nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dy <Plug>(coc-type-definition)
nmap <silent> <leader>di <Plug>(coc-implementation)
nmap <silent> <leader>dr <Plug>(coc-references)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
