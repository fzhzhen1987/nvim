### [nvim_lua学习](https://github.com/glepnir/nvim-lua-guide-zh)  

### **windows nvim markdown**  
在powershell中执行以下代码
```shell
md ~\AppData\Local\nvim\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\AppData\Local\nvim\autoload\plug.vim"
  )
)
```
在nvim中执行以下命令
```shell
:call mkdp#util#install()
```
### 将查询结果输出到buffer  
```shell
显示:hi
:enew|pu=execute('hi')

显示:lua print(vim.inspect(package.loaded))
enew|pu=execute('lua print(vim.inspect(package.loaded))')

显示:lua print("Leaderf gtags -s %s --top --auto-preview")
enew|pu=execute('lua print(\"Leaderf gtags -s %s --top --auto-preview\")')

显示:lua print(vim.fn.printf("Leaderf gtags -s %s --top --auto-preview", vim.fn.expand('<cword>')))

:echo  printf('Leaderf gtags -s %s --top --auto-preview', expand('<cword>'))
:execute  printf('Leaderf gtags -s %s --top --auto-preview', expand('<cword>'))
```

### nvim 设置选项  

```shell
查看所有可配置选项
:h option-list

查询某个选项当前配置,以background为例
:set background?
```

--------
<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
	<th style="text-align:center;" colspan="3">1. markdown keybind</th>
</tr>
<tr>
	<th style="text-align:center;">Key</th>
	<th style="text-align:left;">Function</th>
</tr>
</thead>

<tbody>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>`</kbd></td>
	<td style="text-align:left;">跳转到下个锚点</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>tab</kbd></td>
	<td style="text-align:left;">跳转到下个锚点(并换行)</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>1</kbd></td>
	<td style="text-align:left;">我最常用的标题</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>2</kbd></td>
	<td style="text-align:left;">一级标题</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>3</kbd></td>
	<td style="text-align:left;">二级标题</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>space</kbd></td>
	<td style="text-align:left;">分割线</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>s</kbd></td>
	<td style="text-align:left;">代码大块</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>h</kbd></td>
	<td style="text-align:left;">红色字体</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>m</kbd></td>
	<td style="text-align:left;">复选框可在[x],表示打勾</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>l</kbd></td>
	<td style="text-align:left;">添加链接</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>p</kbd></td>
	<td style="text-align:left;">添加图片</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>c</kbd></td>
	<td style="text-align:left;">文字居中</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>u</kbd></td>
	<td style="text-align:left;">一行红色字</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>a</kbd></td>
	<td style="text-align:left;"><div style="color: red;">可折叠代码段,用于添加log</div></td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>e</kbd></td>
	<td style="text-align:left;"><div style="color: red;">可折叠图片</div></td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>j</kbd></td>
	<td style="text-align:left;">斜体</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>k</kbd></td>
	<td style="text-align:left;">粗体</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>d</kbd></td>
	<td style="text-align:left;">删除线</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>b</kbd></td>
	<td style="text-align:left;">一行代码块</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>`</kbd>+<kbd>n</kbd></td>
	<td style="text-align:left;">显示看起来像按键</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>space</kbd>+<kbd>mm</kbd></td>
	<td style="text-align:left;"><div style="color: red;">开启做表模式,配合"|".":"可以控制对齐方式</div></td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>space</kbd>+<kbd>mt</kbd></td>
	<td style="text-align:left;"><div style="color: red;">格式化表格</div></td>
</tr>


</tbody>
</table>





<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
	<th style="text-align:center;" colspan="3">2. 基本操作</th>
</tr>
<tr>
	<th style="text-align:center;">Key</th>
	<th style="text-align:left;">Function</th>
</tr>
<tr>
	<th style="text-align:center;" colspan="3">2-1. 光标移动</th>
</tr>
</thead>

<tbody>
<tr>
	<td style="text-align:left;"><kbd>W</kbd></td>
	<td style="text-align:left;">光标向上移动5行</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>S</kbd></td>
	<td style="text-align:left;">光标向下移动5行</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>A</kbd></td>
	<td style="text-align:left;">光标向左移动5行</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>D</kbd></td>
	<td style="text-align:left;">光标向右移动5行</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>a</kbd></td>
	<td style="text-align:left;">光标向左边单词移动</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>d</kbd></td>
	<td style="text-align:left;">光标向右边单词移动</td>
</tr>
<tr>
	<th style="text-align:center;" colspan="3">2-2. 删除</th>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>j</kbd></td>
	<td style="text-align:left;">删除光标所在单词</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>h</kbd></td>
	<td style="text-align:left;">向前删除字母</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>z</kbd></td>
	<td style="text-align:left;">删除多余的空格</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>ENTER</kbd></td>
	<td style="text-align:left;">取消 [删除多余空格] 后的高亮</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>j</kbd> <kbd>j</kbd></td>
	<td style="text-align:left;">删除整行</td>
</tr>
<tr>
	<th style="text-align:center;" colspan="3">2-3. 进入插入模式</th>
</tr>
<tr>
	<td style="text-align:left;"><kbd>s</kbd></td>
	<td style="text-align:left;">删除当前字母并进入插入模式</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>e</kbd></td>
	<td style="text-align:left;">当前光标后插入</td>
</tr>
<tr>
	<th style="text-align:center;" colspan="3">2-4. 选定文本复制/粘贴/删除</th>
</tr>
<tr>
	<td style="text-align:left;"><kbd>v</kbd></td>
	<td style="text-align:left;">进入选择文本模式(行文本选择模式)</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ENTER</kbd></td>
	<td style="text-align:left;">区域选择</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>v</kbd></td>
	<td style="text-align:left;">进入选择文本模式(矩形的文本选择)</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>c</kbd></td>
	<td style="text-align:left;">复制</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>p</kbd></td>
	<td style="text-align:left;">粘贴</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>r</kbd></td>
	<td style="text-align:left;"><div style="color: red;">在插入模式下粘贴</div></td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>j</kbd></td>
	<td style="text-align:left;">删除选定区域</td>
</tr>


</tbody>
</table>





<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
	<th style="text-align:center;" colspan="3">3. 分屏操作</th>
</tr>
<tr>
	<th style="text-align:center;">Key</th>
	<th style="text-align:left;">Function</th>
</tr>
</thead>

<tbody>
<tr>
	<td style="text-align:left;"><kbd>wd</kbd></td>
	<td style="text-align:left;">右分屏</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>wa</kbd></td>
	<td style="text-align:left;">左分屏</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ww</kbd></td>
	<td style="text-align:left;">上分屏</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ws</kbd></td>
	<td style="text-align:left;">下分屏</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>d</kbd></td>
	<td style="text-align:left;">窗口焦点右移</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>a</kbd></td>
	<td style="text-align:left;">窗口焦点左移</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>w</kbd></td>
	<td style="text-align:left;">窗口焦点上移</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>s</kbd></td>
	<td style="text-align:left;">窗口焦点下移</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>ALT</kbd>+<kbd>d</kbd></td>
	<td style="text-align:left;">当前窗口变宽</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>ALT</kbd>+<kbd>a</kbd></td>
	<td style="text-align:left;">当前窗口变窄</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>ALT</kbd>+<kbd>w</kbd></td>
	<td style="text-align:left;">当前窗口变高</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>ALT</kbd>+<kbd>s</kbd></td>
	<td style="text-align:left;">当前窗口变矮</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>wn</kbd></td>
	<td style="text-align:left;">新tab标签</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>gn</kbd></td>
	<td style="text-align:left;">标签焦点向右移动</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>gp</kbd></td>
	<td style="text-align:left;">标签焦点向左移动</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>H</kbd></td>
	<td style="text-align:left;">buffer焦点左移</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>L</kbd></td>
	<td style="text-align:left;">buffer焦点右移</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>we</kbd></td>
	<td style="text-align:left;">窗口排部由上下变左右</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>wo</kbd></td>
	<td style="text-align:left;">窗口排部由左右变上下</td>
</tr>


</tbody>
</table>





<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
	<th style="text-align:center;" colspan="3">4. nvim-tree</th>
</tr>
<tr>
	<th style="text-align:center;">Key</th>
	<th style="text-align:left;">Function</th>
</tr>
</thead>

<tbody>
<tr>
	<td style="text-align:left;"><kbd>n</kbd></td>
	<td style="text-align:left;">new新建文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>r</kbd></td>
	<td style="text-align:left;">rename重命名文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>c</kbd></td>
	<td style="text-align:left;">copy文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>x</kbd></td>
	<td style="text-align:left;">cut文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>p</kbd></td>
	<td style="text-align:left;">paste粘贴文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>d</kbd></td>
	<td style="text-align:left;">delete文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>gn</kbd></td>
	<td style="text-align:left;">复制文件名</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>gp</kbd></td>
	<td style="text-align:left;">复制文件绝对路径</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>q</kbd></td>
	<td style="text-align:left;">关闭nvim-tree窗口</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>b</kbd></td>
	<td style="text-align:left;">收起展开的部分</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>t</kbd></td>
	<td style="text-align:left;">在新tab打开文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>b</kbd></td>
	<td style="text-align:left;">跳到父节点</td>
</tr>


</tbody>
</table>





<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
	<th style="text-align:center;" colspan="3">5. 编程相关</th>
</tr>
<tr>
	<th style="text-align:center;">Key</th>
	<th style="text-align:left;">Function</th>
</tr>
<tr>
	<th style="text-align:center;" colspan="3">5-1. gtags + LeaderF</th>
</tr>
</thead>

<tbody>
<tr>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>.</kbd></td>
	<td style="text-align:left;">函数定义查看</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>,</kbd></td>
	<td style="text-align:left;">函数被调用位置</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>p</kbd></td>
	<td style="text-align:left;">召回最后的搜索结果</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>js</kbd></td>
	<td style="text-align:left;">变量相关的结果</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jf</kbd></td>
	<td style="text-align:left;">查找光标所在include文件的路径</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>ji</kbd></td>
	<td style="text-align:left;">显示当前光标所在的include文件被那些文件include</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>o</kbd></td>
	<td style="text-align:left;">返回gtags操作之前的位置</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>i</kbd></td>
	<td style="text-align:left;">前进到gtags操作之后的位置</td>
</tr>
<tr>
	<th style="text-align:center;" colspan="3">5-2. lsp</th>
</tr>
<tr>
	<td style="text-align:left;"><kbd>J</kbd></td>
	<td style="text-align:left;">变量/函数声明</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jt</kbd></td>
	<td style="text-align:left;">type定义</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jd</kbd></td>
	<td style="text-align:left;">函数定义</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jD</kbd></td>
	<td style="text-align:left;">函数声明</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jr</kbd></td>
	<td style="text-align:left;">变量/函数引用位置</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jn</kbd></td>
	<td style="text-align:left;">变量/函数重命名</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>j[</kbd></td>
	<td style="text-align:left;">跳到诊断上一个</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>j]</kbd></td>
	<td style="text-align:left;">跳到诊断下一个</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jw</kbd></td>
	<td style="text-align:left;">列出所有诊断内容</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jo</kbd></td>
	<td style="text-align:left;">未知</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jp</kbd></td>
	<td style="text-align:left;">当前文件的所属的根位置</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>p</kbd></td>
	<td style="text-align:left;">预览搜索结果</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>n</kbd>预览下翻页</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>ALT</kbd>+<kbd>m</kbd>预览上翻页</td>
</tr>
<tr>
	<th style="text-align:center;" colspan="3">5-3. LeaderF和fzf</th>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>u</kbd></td>
	<td style="text-align:left;">显示当前buf中的所有tag</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>e</kbd></td>
	<td style="text-align:left;">打开预览页面<kbd>CTRL</kbd>+<kbd>j</kbd>下一行 <kbd>CTRL</kbd>+<kbd>k</kbd>上一行</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jh</kbd></td>
	<td style="text-align:left;">回顾历史查询</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>jl</kbd></td>
	<td style="text-align:left;">行模式查看整个文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>?</kbd></td>
	<td style="text-align:left;">在当前文件查找某个单词</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>ff</kbd></td>
	<td style="text-align:left;">查找某个文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>fg</kbd></td>
	<td style="text-align:left;">查找某个文件属于git管理</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>fh</kbd></td>
	<td style="text-align:left;">查看搜索的历史纪录</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>fa</kbd></td>
	<td style="text-align:left;">模糊搜索内容</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>fr</kbd></td>
	<td style="text-align:left;">精确搜索内容</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>fa</kbd></td>
	<td style="text-align:left;">模糊搜索内容</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>fr</kbd></td>
	<td style="text-align:left;">精确搜索内容</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>rg</kbd></td>
	<td style="text-align:left;">全盘模糊搜索内容</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>Ctrl</kbd>+<kbd>o</kbd></td>
	<td style="text-align:left;">横向分屏</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>Ctrl</kbd>+<kbd>e</kbd></td>
	<td style="text-align:left;">竖向分屏</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>Ctrl</kbd>+<kbd>r</kbd></td>
	<td style="text-align:left;">预览结果</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">预览搜索翻页<kbd>CTRL</kbd>+<kbd>j</kbd>和<kbd>CTRL</kbd>+<kbd>k</kbd></td>
</tr>


</tbody>
</table>




<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
	<th style="text-align:center;" colspan="4">6. 多光标编辑</th>
</tr>
<tr>
	<th style="text-align:center;">Key</th>
	<th style="text-align:center;">sub-Key</th>
	<th style="text-align:center;">sub-sub-Key</th>
	<th style="text-align:left;">Function</th>
</tr>
</thead>

<tbody>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>k</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">标记当前单词</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>k</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">标记下一个相同单词</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>q</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">取消标记当前标记的单词</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>n</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">跳转到下一个相同的单词</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>N</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">跳转到上一个相同的单词</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>I</kbd></td>
	<td style="text-align:left;">插入在词头</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>a</kbd></td>
	<td style="text-align:left;">插入在词尾</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>d</kbd></td>
	<td style="text-align:left;">删除选中单词</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>c</kbd></td>
	<td style="text-align:left;">删除选中单词后写入</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>u</kbd></td>
	<td style="text-align:left;">撤销编辑</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>k</kbd></td>
	<td style="text-align:left;">取消所有选定</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>v</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">选定区域开始</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>k</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">标记当前选定区域</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>v</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">如果使用<kbd>n</kbd>跳过,可用<kbd>v</kbd>划定相同区域后<kbd>CTRL</kbd>+<kbd>k</kbd></td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>UP</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">向上添加光标</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>DOWN</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">向下添加光标</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>I</kbd></td>
	<td style="text-align:left;">插入在词头</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>i</kbd></td>
	<td style="text-align:left;">插入在当前位置</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>A</kbd></td>
	<td style="text-align:left;">插入在词尾</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>x</kbd></td>
	<td style="text-align:left;">删除字母</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>c</kbd> <kbd>c</kbd></td>
	<td style="text-align:left;">删除整行后编辑</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>u</kbd></td>
	<td style="text-align:left;">撤销编辑</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>j</kbd></td>
	<td style="text-align:left;">选定的行集体向下移动</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>k</kbd></td>
	<td style="text-align:left;">选定的行集体向上移动</td>
</tr>


</tbody>
</table>





<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
	<th style="text-align:center;" colspan="3">7. tig和lazygit</th>
</tr>
<tr>
	<th style="text-align:center;">Key</th>
	<th style="text-align:left;">Function</th>
</tr>


<tbody>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>gt</kbd></td>
	<td style="text-align:left;">tig</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>gT</kbd></td>
	<td style="text-align:left;">当前文件 commit 列表</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>gb</kbd></td>
	<td style="text-align:left;">tig blame 当前文件</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>gn</kbd></td>
	<td style="text-align:left;">跳到下一个修改块</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>gp</kbd></td>
	<td style="text-align:left;">跳到上一个修改块</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>gl</kbd></td>
	<td style="text-align:left;">高亮修改块</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>h</td>
	<td style="text-align:left;">显示当前修改块内容</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>gg</kbd></td>
	<td style="text-align:left;">lazygit</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>SPACE</kbd>+<kbd>gf</kbd></td>
	<td style="text-align:left;">tig中grep</td>
</tr>


</tbody>
</table>




<table>
<colgroup>
<col style="text-align:left;"/>
<col style="text-align:left;"/>
</colgroup>

<thead>
<tr>
	<th style="text-align:center;" colspan="4">8. 使用{}包裹选定内容</th>
</tr>
<tr>
	<th style="text-align:center;">Key</th>
	<th style="text-align:center;">sub-Key</th>
	<th style="text-align:left;">Function</th>
</tr>
</thead>

<tbody>
<tr>
	<td style="text-align:left;"><kbd>CTRL</kbd>+<kbd>m</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">选定要包裹的内容</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>S</kbd>+<kbd>{</kbd></td>
	<td style="text-align:left;">使用{}包裹内容</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>S</kbd>+<kbd>}</kbd></td>
	<td style="text-align:left;">使用{}包裹内容</td>
</tr>
<tr>
	<td style="text-align:left;"><kbd>将光标移动到被包裹内容中</kbd></td>
	<td style="text-align:left;"></td>
	<td style="text-align:left;">修改/删除包裹符号</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>cs</kbd>+<kbd>{ 原符号</kbd>+<kbd>( 新符号</kbd></td>
	<td style="text-align:left;">使用()替换{}包裹内容</td>
</tr>
<tr>
	<td style="text-align:left;"></td>
	<td style="text-align:left;"><kbd>js</kbd>+<kbd>{ 待删除的符号</kbd></td>
	<td style="text-align:left;">删除包裹符号</td>
</tr>


</tbody>
</table>

--------
# GTags错误排查
**错误代码**
```shell
gutentags: gtags-cscope job failed, returned: 1
```
**解决步骤**  
1. 添加错误日志追踪功能
```shell
let g:gutentags_define_advanced_commands = 1
```
2.打开运行出错的文件,并命令行打开日志
```
:GutentagsToggleTrace
会将错误信息打印到:messages中
```
# gtags.conf更新
[global下载](https://ftp.gnu.org/pub/gnu/global/)  
```shell
查看主机global的版本
gtags --version

下载对应的版本,展开tar包
wget https://ftp.gnu.org/pub/gnu/global/global-6.6.4.tar.gz -O Global.tar.gz

tar xzvf Global.tar.gz

cp global-6.6.4/gtags.conf ~/.gtags.conf
```

# ccls编译方法
```shell
旧
bear --libear /usr/lib/x86_64-linux-gnu/bear/libear.so make install

新
bear --library /lib/x86_64-linux-gnu/bear/libexec.so -- make install
```

# 查看按键映射

[vim键盘映射](https://zhuanlan.zhihu.com/p/24713018)  

```shell
:map
:nmap
:vmap
:verbose nmap ???
```

