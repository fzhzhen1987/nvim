" 文件编码设置（支持日语文件自动识别）
" 内部编码（Neovim 内部使用的编码）
set encoding=utf-8

" 新文件的默认编码
set fileencoding=utf-8

" 文件编码检测顺序（重要：按此顺序自动检测文件编码）
" 优先检测日语编码，因为 UTF-8 检测太宽松会误判
set fileencodings=ucs-bom,sjis,cp932,euc-jp,iso-2022-jp,utf-8,gbk,gb2312,gb18030,big5,latin1

" 终端编码
set termencoding=utf-8

" 不使用 BOM（字节顺序标记）
set nobomb

" ================== 增强的编码处理功能 ==================

" SJ 命令：用 Shift_JIS 重新打开当前文件
command! SJ call s:ReopenWithSjis()

function! s:ReopenWithSjis()
    let l:filepath = expand('%:p')
    if empty(l:filepath)
        echo "没有打开的文件"
        return
    endif
    execute 'bdelete!'
    execute 'edit ++enc=sjis ' . l:filepath
    echo "已用 Shift_JIS 编码重新打开"
endfunction

" 创建命令来查看当前文件编码信息
command! FileEncodingInfo call s:ShowFileEncodingInfo()

function! s:ShowFileEncodingInfo()
    echo "=== 文件编码信息 ==="
    echo "encoding (内部编码): " . &encoding
    echo "fileencoding (文件编码): " . &fileencoding
    echo "fileencodings (检测顺序): " . &fileencodings
    echo "fileformat (文件格式): " . &fileformat
    echo "bomb (BOM标记): " . &bomb
endfunction

" 查看文件的十六进制
command! HexView %!xxd
command! HexRevert %!xxd -r

" 为可能包含日语的文件添加自动检测和提示
augroup JapaneseFileDetection
    autocmd!
    autocmd BufReadPost *.c,*.h,*.cpp,*.txt,*.log call s:CheckForGarbledText()
augroup END

function! s:CheckForGarbledText()
    " 检查是否有乱码特征
    let l:lines = getline(1, 10)
    let l:garbled_count = 0
    
    for l:line in l:lines
        " 统计非 ASCII 字符
        let l:non_ascii = strlen(substitute(l:line, '[\x00-\x7f]', '', 'g'))
        if l:non_ascii > 0 && strlen(l:line) > 0
            let l:ratio = str2float(l:non_ascii) / str2float(strlen(l:line))
            if l:ratio > 0.3  " 如果超过30%是非ASCII字符
                let l:garbled_count += 1
            endif
        endif
    endfor
    
    " 如果多行看起来像乱码，提示用户
    if l:garbled_count >= 3
        " 延迟显示，避免干扰文件加载
        call timer_start(100, {-> execute('echo "文件可能是日语编码，如果显示乱码请尝试 :SJ"', '')})
    endif
endfunction

" 添加状态栏显示编码信息的函数
function! GetFileEncoding()
    let l:enc = &fileencoding
    if empty(l:enc)
        let l:enc = &encoding
    endif
    return toupper(l:enc)
endfunction
