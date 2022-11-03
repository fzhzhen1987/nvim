let mapleader=" "

"命令行模式补全
cnoremap <C-s> <C-u><CR>
cnoremap <C-f> <right>
cnoremap <C-b> <left>
cnoremap <C-e> <END>
cnoremap <C-a> <HOME>

map u <nop>
map w <nop>


if ($OS == 'Windows_NT')
	map <F2> :source ~/AppData/Local/nvim/init.vim<CR>
else
	map <F2> :source ~/.config/nvim/init.vim<CR>
endif

map <F3> :PlugInstall<CR>
map <F4> :PlugUpdate<CR>

"普通模式下C-c复制文本
vnoremap <C-c> "+y

noremap <LEADER><CR> :nohlsearch<CR>

noremap <C-p> k
noremap <C-n> j
noremap <C-b> h
noremap <C-f> l

inoremap <C-b> <left>
inoremap <C-n> <down>
inoremap <C-p> <up>
inoremap <C-f> <right>

noremap W 5kzz
noremap S 5jzz
noremap A 5h
noremap D 5l


inoremap <C-s> <esc>

map <C-q><C-q> :q!<CR>

"单词移动
noremap a b
""noremap d w
noremap d e

"删除当前单词
"noremap jl dw
noremap <C-j> diw
noremap <C-h> X

noremap e a
noremap <C-a> <home>
noremap <C-e> <end>
inoremap <C-a> <home>
inoremap <C-e> <end>

noremap j d

noremap ; :

"""""""查找光标所在位置单词- =,查找括号'
nmap - *
nmap = #
nmap ' %


"""""""输入括号自动输入匹配括号
"inoremap ' ''<ESC>i
"inoremap " ""<ESC>i
"inoremap ( ()<ESC>i
"inoremap [ []<ESC>i
"inoremap { {<CR>}<ESC>O

map <C-s> :w<CR>
map <C-q> :q<CR>
map Q :wq<CR>
map <A-q> :qa<CR>

noremap  <C-z> <nop>


"ranger
noremap <LEADER>ra :RnvimrToggle<CR>

"删除行尾空格
noremap <C-z> :%s/\s*$//g<CR>

"检查拼写错误
map <LEADER>sc :set spell!<CR>

"Space to Tab,将内容两边加上||(普通模式和可视模式)
nnoremap <LEADER>tt :%s/    /\t/g
vnoremap <LEADER>tt :s/    /\t/g

"标签以及buffer
nnoremap wn mm :tabnew %<CR> `m
nnoremap gn :tabnext<CR>
nnoremap gp :tabprevious<CR>
nnoremap <S-x> :bnext<CR>
nnoremap <S-z> :bprevious<CR>

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

map <A-C-w> :res +1<CR>
map <A-C-s> :res -1<CR>
map <A-C-a> :vertical resize-1<CR>
map <A-C-d> :vertical resize+1<CR>

"上下变为左右,左右变上下
"map k <C-w>t<C-w>H
"map l <C-w>t<C-w>K
map <LEADER>we <C-w>t<C-w>H
map <LEADER>wo <C-w>t<C-w>K
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
