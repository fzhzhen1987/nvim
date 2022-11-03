"autocmd Filetype markdown map <leader>w yiWi[<esc>Ea](<esc>pa)
autocmd InsertEnter *.md setlocal filetype=txt
autocmd InsertLeave *.md setlocal filetype=markdown
autocmd Filetype markdown inoremap <buffer> `` <Esc>/<++><CR>:nohlsearch<CR>"_c4l
autocmd Filetype markdown inoremap <buffer> `<Tab> <Esc>/<++><CR>:nohlsearch<CR>"_c5l<CR>
autocmd Filetype markdown inoremap <buffer> `1 <h4 id="">[<++>]</h>  <Enter><Enter><++><Esc>2kf"a
autocmd Filetype markdown inoremap <buffer> `2 **``**  <++><Esc>F`i
autocmd Filetype markdown inoremap <buffer> `3 ##<Space><Enter><++><Esc>kA

autocmd Filetype markdown inoremap <buffer> `<Space> --------<Enter>
autocmd Filetype markdown inoremap <buffer> `s ```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA
autocmd Filetype markdown inoremap <buffer> `h <font color=red></font><++><Esc>F<F<i
autocmd Filetype markdown inoremap <buffer> `m - [ ] 
autocmd Filetype markdown inoremap <buffer> `l [](<++>)  <++><Esc>F[a
autocmd Filetype markdown inoremap <buffer> `p ![](<++>)  <++><Esc>F[a
autocmd Filetype markdown inoremap <buffer> `c <div style="text-align:center;"></div><++><Esc>F<F<i
autocmd Filetype markdown inoremap <buffer> `u <div style="color: red;"></div><++><Esc>F<F<i
autocmd Filetype markdown inoremap <buffer> `a <details><Enter><summary></summary><Enter><pre class="hljs"><code><Enter><++><Enter></code></pre><Enter></details><Enter><++><Esc>5kf<i
autocmd Filetype markdown inoremap <buffer> `e <details><Enter><summary></summary><Enter><img src= <++> /><Enter></details><Enter><++><Esc>3kf<i

autocmd Filetype markdown inoremap <buffer> `j ** <++><Esc>F*i
autocmd Filetype markdown inoremap <buffer> `k **** <++><Esc>F*hi
autocmd Filetype markdown inoremap <buffer> `d ~~~~ <++><Esc>F~hi

autocmd Filetype markdown inoremap <buffer> `n <kbd></kbd><++><Esc>F>F>a
autocmd Filetype markdown inoremap <buffer> `b `` <++><Esc>F`i
