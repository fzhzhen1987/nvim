-- 查询某个选项 number为例
-- :h number

local G = require('FZH_lua.G')

-- 关闭鼠标,终端颜色,关闭自动换行,高亮匹配括号,自动切换目录,未保存可切换buffer
-- 文件格式,显示输入命令,不显示模式
G.cmd([[
	set termguicolors
	set nowrap
	set showmatch
	set autochdir
	set hidden
	set fileformats=unix,dos,mac
	set showcmd
]])

-- tab设置
-- tabstop: 显示tab长度为2
-- softtabstop=-1: 值为负,会使用shiftwidth的值,两者保持一致
-- shiftwidth=2: 实际tab长度为2,但是没有设置expandtab,所以不生效
G.cmd([[
	set textwidth=80
	set noexpandtab
	set tabstop=2
	set shiftwidth=2
	set softtabstop=-1
	set smarttab
	set autoindent
	set smartindent
	set shiftround
]])


-- 行号,4位行号,高亮当前行,关闭备份,关闭交换,搜索智能区分大小写,高亮搜索结果,实时匹配搜索
-- 关闭编辑备份,关闭撤销备份,分屏右下,
G.cmd([[
	set number
	set numberwidth=4
	set cursorline
	set nobackup
	set noswapfile
	set nowritebackup
	set noundofile
	set smartcase
	set hlsearch
	set wrapscan
	set incsearch
	set showtabline=2
	set splitbelow splitright
	set updatetime=100
]])

-- 文件编码,自动加载
G.cmd([[
	set encoding=utf-8
	set autoread
]])


-- 未细分
G.cmd([[
	set showmode!
	set report=0
	set magic
	set path+=**
	set isfname-==
	set virtualedit=onemore
	set formatoptions-=tc
	set viewoptions=folds,cursor,curdir,slash,unix
	set sessionoptions=curdir,help,tabpages,winsize
	set clipboard=unnamed
	set clipboard+=unnamedplus
	set wildmenu
	set wildignorecase
	set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
	set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
	set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
	set wildcharm=<C-z>
	set history=1000
	set ignorecase
	set infercase
	set complete=.,w,b,k
	set linebreak
	set breakat=\ \»;:,!?
	set nostartofline
	set whichwrap+=h,l,<,>,[,],~
	set switchbuf=useopen,vsplit
	set backspace=indent,eol,start
	set diffopt=filler,iwhite
	set completeopt=longest,noinsert,menuone,noselect,preview
	set noruler
	set shortmess+=c
	set scrolloff=3
	set list
	set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←
	set title
	set titlelen=95
	set fillchars+=vert:\|
	set fillchars=eob:\ 
	set matchpairs+=<:>
	set matchtime=1
	set winwidth=30
	set winminwidth=10
	set winminheight=1
	set pumheight=15
	set helpheight=12
	set previewheight=12
	set noequalalways
	set laststatus=2
	set display=lastline
	set signcolumn=yes
	set synmaxcol=2500
]])


vim.scriptencoding = "utf-8"

