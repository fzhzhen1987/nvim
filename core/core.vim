"首次安装使用
"============
"Vim-Plug的首次下载安装

if ($OS == 'Windows_NT')
	if empty(glob('$HOMEDRIVE\$HOMEPATH\AppData\Local\nvim\autoload\plug.vim'))
		silent !curl -fLo \%HOMEDRIVE\%/\%HOMEPATH\%/AppData/Local/nvim/autoload/plug.vim --create-dirs
				\  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif

	source ~/AppData/Local/nvim/core/general_config.vim
	source ~/AppData/Local/nvim/core/key_bindings.vim
	source ~/AppData/Local/nvim/core/language_config.vim
	source ~/AppData/Local/nvim/core/md-snippets.vim
	source ~/AppData/Local/nvim/core/plug_list.vim
	source ~/AppData/Local/nvim/core/special_config.vim
	source ~/AppData/Local/nvim/core/theme.vim
else
	if empty(glob('~/.config/nvim/autoload/plug.vim'))
		silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif

	source ~/.config/nvim/core/general_config.vim
	source ~/.config/nvim/core/key_bindings.vim
	source ~/.config/nvim/core/language_config.vim
	source ~/.config/nvim/core/md-snippets.vim
	source ~/.config/nvim/core/plug_list.vim
	source ~/.config/nvim/core/special_config.vim
	source ~/.config/nvim/core/theme.vim
endif

