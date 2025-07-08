" 文件编码设置（支持日语文件自动识别）
" 内部编码（Neovim 内部使用的编码）
set encoding=utf-8
" 新文件的默认编码
set fileencoding=utf-8
" 文件编码检测顺序（重要：UTF-8 优先，避免误判）
" UTF-8 应该在前面，因为它的检测更严格
set fileencodings=ucs-bom,utf-8,sjis,cp932,euc-jp,iso-2022-jp,gbk,gb2312,gb18030,big5,latin1
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
    " 保存当前文件的原始编码
    let l:original_fenc = &fileencoding
    execute 'bdelete!'
    execute 'edit ++enc=sjis ' . l:filepath
    echo "已用 Shift_JIS 编码重新打开 (原编码: " . l:original_fenc . ")"
endfunction

" UTF8 命令：用 UTF-8 重新打开当前文件
command! UTF8 call s:ReopenWithUTF8()
function! s:ReopenWithUTF8()
    let l:filepath = expand('%:p')
    if empty(l:filepath)
        echo "没有打开的文件"
        return
    endif
    let l:original_fenc = &fileencoding
    execute 'bdelete!'
    execute 'edit ++enc=utf-8 ' . l:filepath
    echo "已用 UTF-8 编码重新打开 (原编码: " . l:original_fenc . ")"
endfunction

" 保存文件时保持原有编码
command! -nargs=? SaveAsEncoding call s:SaveAsEncoding(<q-args>)
function! s:SaveAsEncoding(encoding)
    if empty(a:encoding)
        echo "用法: :SaveAsEncoding <编码> (如 utf-8, sjis, cp932)"
        return
    endif
    execute 'set fileencoding=' . a:encoding
    write
    echo "已保存为 " . a:encoding . " 编码"
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
    echo ""
    echo "提示: 使用 :SJ 重新以 Shift_JIS 打开"
    echo "      使用 :UTF8 重新以 UTF-8 打开"
    echo "      使用 :SaveAsEncoding <编码> 另存为指定编码"
endfunction

" 查看文件的十六进制
command! HexView %!xxd
command! HexRevert %!xxd -r

" 改进的乱码检测函数
augroup JapaneseFileDetection
    autocmd!
    autocmd BufReadPost *.c,*.h,*.cpp,*.txt,*.log call s:CheckForGarbledText()
augroup END

function! s:CheckForGarbledText()
    " 只在非 UTF-8 编码时检查
    if &fileencoding == 'utf-8' || &fileencoding == ''
        return
    endif
    
    " 检查是否有乱码特征
    let l:lines = getline(1, min([line('$'), 20]))  " 检查前20行
    let l:garbled_patterns = 0
    
    for l:line in l:lines
        " 检查常见的乱码模式
        if l:line =~ '[�？]' || l:line =~ '[\x80-\xff]\{3,}'
            let l:garbled_patterns += 1
        endif
        
        " 检查是否包含日语特征但显示异常
        if l:line =~ '[ｱ-ﾝ]' && &fileencoding != 'sjis' && &fileencoding != 'cp932'
            let l:garbled_patterns += 1
        endif
    endfor
    
    " 如果发现乱码模式，提示用户
    if l:garbled_patterns >= 2
        " 延迟显示，避免干扰文件加载
        call timer_start(100, function('s:ShowEncodingHint'))
    endif
endfunction

function! s:ShowEncodingHint(timer)
    echohl WarningMsg
    echo "文件可能有编码问题。当前编码: " . &fileencoding
    echo "尝试: :UTF8 (UTF-8) 或 :SJ (Shift_JIS) 或 :FileEncodingInfo 查看详情"
    echohl None
endfunction

" 添加状态栏显示编码信息的函数
function! GetFileEncoding()
    let l:enc = &fileencoding
    if empty(l:enc)
        let l:enc = &encoding
    endif
    " 添加警告标记
    if l:enc != 'utf-8' && l:enc != ''
        return '⚠ ' . toupper(l:enc)
    endif
    return toupper(l:enc)
endfunction

" 防止意外改变编码的保护措施
augroup EncodingProtection
    autocmd!
    " 在保存前确认非 UTF-8 编码
    autocmd BufWritePre * call s:CheckEncodingBeforeSave()
augroup END

function! s:CheckEncodingBeforeSave()
    " 如果文件编码不是 UTF-8 且文件是新建的，提醒用户
    if &fileencoding != 'utf-8' && &fileencoding != '' && !filereadable(expand('%:p'))
        let l:choice = confirm("新文件将以 " . &fileencoding . " 编码保存，是否继续？", "&Yes\n&No\n&UTF-8", 3)
        if l:choice == 2
            " 取消保存
            throw "Save cancelled"
        elseif l:choice == 3
            " 改为 UTF-8
            set fileencoding=utf-8
            echo "已改为 UTF-8 编码"
        endif
    endif
endfunction
