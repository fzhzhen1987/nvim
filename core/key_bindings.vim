let mapleader=" "

"命令行模式补全
cnoremap <C-f> <right>
cnoremap <C-b> <left>

map u <nop>
map w <nop>

"cnoremap <C-n> <C-g>
"cnoremap <C-p> <C-t>
"暂时
"cnoremap <C-g> <esc>
"map <F1> :edit ~/.config/nvim/core/core.vim<CR>

map <F2> :source ~/.config/nvim/init.vim<CR>
map <F3> :PlugInstall<CR>
map <F4> :PlugUpdate<CR>

"普通模式下C-c复制文本
vnoremap <C-c> "+y

noremap <LEADER><CR> :nohlsearch<CR>

inoremap <C-g> <esc>

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
noremap <C-a> ^
noremap <C-e> g_
inoremap <C-a> <home>
inoremap <C-e> <end>

noremap j d

noremap ; :

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

"标签
nnoremap wp :-tabnext<CR>
nnoremap wn :+tabnext<CR>
