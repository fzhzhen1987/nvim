# Neovim 配置文档

**配置路径**: `/home/mav/.config/nvim/`
**更新时间**: 2025-10-25
**Neovim 版本**: 0.9.4+
**插件管理**: lazy.nvim

---

## 目录

- [一、快速开始](#一快速开始)
- [二、插件列表](#二插件列表)
- [三、键位映射](#三键位映射)
- [四、配置结构](#四配置结构)
- [五、自定义功能](#五自定义功能)
- [六、维护说明](#六维护说明)

---

## 一、快速开始

### 1.1 首次安装

```bash
# 1. 备份旧配置（如果存在）
mv ~/.config/nvim ~/.config/nvim.bak

# 2. 克隆或复制配置
cp -r /path/to/nvim ~/.config/

# 3. 启动 Neovim，插件会自动安装
nvim

# 4. 编译必要的插件
:LeaderfInstallCExtension  # LeaderF C 扩展
```

### 1.2 依赖要求

**必需**：
- Neovim >= 0.9.4
- Git
- ripgrep (rg) - 用于 Telescope 和 LeaderF 搜索
- fd - 用于文件查找
- Node.js - LSP 服务器
- gcc/make - 编译 telescope-fzf-native

**可选**：
- global (GNU GLOBAL) - gtags 支持
- clangd - C/C++ LSP
- tig - Git TUI
- yazi - 文件管理器

### 1.3 常用命令

```vim
:Lazy sync          " 同步插件（安装/更新）
:Lazy restore       " 恢复到锁定版本
:checkhealth        " 检查配置健康状态
:LspInfo            " 查看 LSP 状态
```

---

## 二、插件列表

### 2.1 插件统计

| 分类 | 数量 | 占比 |
|------|------|------|
| LSP 与补全 | 9 | 23% |
| 代码编辑与高亮 | 5 | 13% |
| 编辑器增强 | 11 | 28% |
| Git 集成 | 1 | 3% |
| 工具与查找 | 7 | 18% |
| UI 与主题 | 5 | 13% |
| **总计** | **39** (含 lazy.nvim) | **100%** |

**版本固定率**: 100% - 所有插件都已锁定版本，确保配置稳定性

### 2.2 核心插件

#### LSP 与补全
- **nvim-lspconfig** (v0.1.*) - LSP 配置引擎
- **nvim-cmp** (v0.0.2) - 自动补全引擎
- **LuaSnip** (v2.4.0) - 代码片段引擎

#### 代码编辑
- **nvim-treesitter** (v0.9.2) - 语法树解析和高亮
- **vim-gutentags** - 自动生成 ctags/gtags
- **Comment.nvim** (v0.8.0) - 智能注释
- **nvim-surround** (v3.1.6) - 包围符操作
- **auto-pairs** (v2.0.0) - 自动配对括号

#### 查找工具
- **telescope.nvim** (0.1.0) - 模糊查找系统
- **LeaderF** (v1.25) - 文件/代码查找（支持 gtags）
- **nvim-bqf** (v1.1.1) - QuickFix 增强

#### Git
- **vim-gitgutter** - Git 差异显示和导航

#### UI
- **bufferline.nvim** (v3.7.0) - 顶部标签栏
- **lualine.nvim** (compat-nvim-0.5) - 底部状态栏
- **which-key.nvim** - 键位提示面板
- **vim-hybrid-material** - 主题

#### 其他
- **undotree** - 撤销历史树
- **vim-visual-multi** (v0.5.8) - 多光标编辑
- **yazi.nvim** - yazi 文件管理器集成（浮动窗口）
- **tig-explorer.vim** - Git TUI 集成

*完整插件列表见文末附录*

---

## 三、键位映射

### 3.1 核心理念

本配置采用了**高度定制化**的键位映射，**禁用了部分 vim 原生功能**，重新设计了更符合个人习惯的键位布局：

- **Emacs 风格移动** (Ctrl+p/n/b/f)
- **重新映射核心键** (j→删除, a→单词前移, d→单词尾移)
- **自定义代码块跳转** ([[/]]/{ /})
- **Space 为 Leader 键**

### 3.2 重要改动

#### 禁用的原生功能
| 原生键 | 原功能 | 原因 |
|--------|--------|------|
| u | 撤销 | 使用 Ctrl+r 调用 undotree |
| w | 单词前移 | 已禁用 |
| l | 右移 | 改为滚屏功能 |
| {, } | 段落跳转 | 改为代码块跳转 |
| [[, ]], [], ][, [{, ]} | 原生方括号跳转 | 重新设计 |

#### 重新映射的核心键
| 新键 | 功能 | 原键 |
|------|------|------|
| j | 删除 | d |
| a | 单词前移 | b |
| d | 单词尾移 | e |
| e | append | a |
| ; | 命令模式 | : |
| ' | 匹配括号 | % |

### 3.3 常用键位速查

#### 基础移动
```
Ctrl+p/n/b/f  - 上/下/左/右移动（Emacs风格）
W / S         - 快速上下移动 5 行
L / l         - 向上/下滚动一行
```

#### 代码块跳转 (自定义)
```
[[  - 跳到外层块开始 {
]]  - 跳到外层块结束 }
{   - 在当前函数内跳到下一个 {
}   - 在当前函数内跳到下一个 }
```

#### 标签页与缓冲区
```
wn          - 新建标签页
gn / gp     - 下/上一个标签页
Shift+Tab   - 关闭当前 buffer
Shift+x/z   - 下/上一个 buffer
```

#### LSP 功能
```
gd  - 跳转到定义
gD  - 跳转到声明
gi  - 查找实现
gt  - 类型定义
gr  - 入调用（谁调用我）
go  - 出调用（我调用谁）
gR  - 查找所有引用
gs  - 当前文档符号
gS  - 工作区符号搜索
J   - LSP 悬浮文档
ga  - 代码操作/修复
Space+rn - LSP 重命名
```

#### Space 组合键（精选）
```
Space+c      - 代码注释
Space+gf     - 代码格式化
Space+gg     - 搜索光标下的词
Space+gG     - 全局内容搜索
Space+q      - 切换 QuickFix
Space+ra     - 打开 yazi 文件管理器
Space+rt     - 打开 Tig
Space+ch     - 头/源文件切换
```

#### Alt 组合键
```
Alt+.  - 跳转到定义（gtags）
Alt+,  - 查找引用（gtags）
Alt+r  - 一键编译运行
Alt+d/w/a/s - 窗口焦点移动（右/上/左/下）
```

#### Git
```
h           - Git 预览修改块
Space+gp/gn - Git 上/下一个修改块
Space+gh    - Git 切换行高亮
```

#### 其他
```
Ctrl+s    - 保存
Q         - 保存并退出
Ctrl+r    - 撤销历史树
Ctrl+k    - 多光标（vim-visual-multi）
```

*完整键位列表见文末附录*

---

## 四、配置结构

```
~/.config/nvim/
├── init.lua                    # 入口文件
├── lazy-lock.json              # 插件版本锁定文件
├── README.md                   # 本文档
│
├── lua/
│   ├── core/                   # 核心配置
│   │   ├── autocmds.lua        # 自动命令
│   │   ├── compiler.lua        # 一键编译运行
│   │   ├── encoding.lua        # 编码处理（日语支持）
│   │   ├── highlights.lua      # 高亮设置
│   │   ├── keymaps.lua         # 键位映射
│   │   ├── options.lua         # Neovim 选项
│   │   ├── project.lua         # 项目管理
│   │   ├── theme.lua           # 主题设置
│   │   └── utils.lua           # 工具函数
│   │
│   ├── plugins/                # 插件定义
│   │   ├── init.lua            # 插件初始化
│   │   ├── coding.lua          # 代码编辑插件
│   │   ├── editor.lua          # 编辑器增强
│   │   ├── git.lua             # Git 集成
│   │   ├── lsp.lua             # LSP 相关
│   │   ├── markdown.lua        # Markdown 支持
│   │   ├── tools.lua           # 工具插件
│   │   └── ui.lua              # UI 和主题
│   │
│   ├── lsp/                    # LSP 配置
│   │   ├── init.lua            # LSP 初始化
│   │   ├── lsp_base.lua        # 基础配置
│   │   ├── clangd.lua          # Clangd 配置
│   │   ├── completion.lua      # 补全配置
│   │   └── lsp_automation.lua  # 自动化
│   │
│   └── config/                 # 插件配置
│       ├── bufferline.lua      # bufferline 配置
│       ├── lualine.lua         # lualine 配置
│       ├── plugins.lua         # 通用插件配置
│       ├── telescope.lua       # telescope 配置
│       └── whichkey.lua        # which-key 键位定义
│
└── after/                      # 延迟加载配置
    └── ftplugin/               # 文件类型插件
```

### 4.1 加载顺序

1. `init.lua` - 设置 mapleader，加载 lazy.nvim
2. `core/options.lua` - Neovim 基础选项
3. `core/encoding.lua` - 编码处理
4. `core/keymaps.lua` - 基础键位映射
5. `plugins/` - 插件定义和延迟加载
6. `lsp/` - LSP 配置
7. `core/project.lua` - 项目管理
8. `core/theme.lua` - 主题加载
9. `core/highlights.lua` - 高亮设置
10. `core/autocmds.lua` - 自动命令
11. `core/compiler.lua` - 编译运行

---

## 五、自定义功能

### 5.1 编码自动识别（日语支持）

**文件**: `lua/core/encoding.lua`

- 自动识别 Shift-JIS、EUC-JP、UTF-8 编码
- 读取时转换为 UTF-8
- 保存时保持原编码
- 支持 BOM 标记

**触发**：打开 `.c`, `.h`, `.cpp` 文件时自动识别

### 5.2 一键编译运行

**文件**: `lua/core/compiler.lua`
**快捷键**: `Alt+r`

支持的语言：
- C/C++ - gcc/g++ 编译并运行
- Python - python3 运行
- Java - javac 编译并运行
- Go - go run
- JavaScript - node 运行
- Shell - bash 运行
- HTML - Chrome 打开
- Markdown - MarkdownPreview
- LaTeX - VimtexCompile

### 5.3 代码块跳转

**文件**: `lua/core/keymaps.lua` (248-307行)

**功能**：
- `[[` / `]]` - 跳到外层块开始/结束（向外跳转）
- `{` / `}` - 在**当前函数内**跳到下一个 `{` / `}`（向内跳转）

**特点**：
- 跳转范围限制在当前函数内，不会跨函数
- 使用 `searchpairpos()` 智能匹配括号
- 超出范围时提示并保持原位置

### 5.4 智能 Telescope 搜索

**文件**: `lua/config/telescope.lua`

- 搜索后自动高亮匹配词
- 支持 ripgrep 参数（`Space+gG`）
- 光标下单词搜索（`Space+gg`）

### 5.5 Surround 包围符操作

**文件**: `lua/config/plugins.lua`, `lua/config/whichkey.lua`, `lua/core/text_object_picker.lua`

**功能**：智能添加、删除、修改包围符（引号、括号、标签等）

**键位**：`Space+t` 系列（禁用所有默认键位）

**特点**：
- `Space+ta` - 弹窗选择文本对象（iw/aw/i(/a(/i[/a[等）
- 支持多种包围符：`"` `'` `` ` `` `(` `[` `{` `<` 和 HTML 标签
- Visual 模式下直接环绕选中内容
- 支持新行模式（格式化添加包围符）

**使用示例**：
```
# 添加引号到单词
光标在 hello 上 → Space+ta → 选择 iw → 输入 " → "hello"

# 删除括号
光标在 (hello) 的括号内 → Space+td → 输入 ( → hello

# 修改引号类型
光标在 "hello" 的引号内 → Space+tc → 输入 " → 输入 ' → 'hello'

# Visual 模式添加
选中文本 → Space+tv → 输入 ( → (选中的文本)
```

### 5.6 项目管理

**文件**: `lua/core/project.lua`

- 自动检测项目根目录（通过 `.git`, `Makefile` 等）
- 自动切换工作目录到项目根
- gtags 自动更新

---

## 六、维护说明

### 6.1 更新插件

```vim
" 所有插件都已锁定版本，Lazy update 不会自动更新

" 手动更新某个插件的步骤：
" 1. 在 GitHub 查看插件的新版本/commit
" 2. 编辑 lua/plugins/*.lua，修改 version 或 commit
" 3. 保存并重启 Neovim
" 4. 执行 :Lazy sync

" 示例：更新 nvim-cmp
" lua/plugins/lsp.lua:27
" version = "v0.0.2"  ->  version = "v0.0.3"
```

### 6.2 添加新插件

1. 在对应的 `lua/plugins/*.lua` 中添加插件定义：

```lua
{
    "author/plugin-name",
    version = "v1.0.0",  -- 锁定版本
    lazy = true,         -- 延迟加载
    event = "VeryLazy",  -- 加载时机
    config = function()
        -- 配置代码
    end,
}
```

2. 重启 Neovim，插件会自动安装

### 6.3 版本管理策略

**推荐做法**：
1. 新插件先不锁定版本，测试稳定后再锁定
2. 使用 `version = "vX.X.X"` 优先于 `commit`
3. 核心插件（LSP、补全）必须锁定版本
4. 主题和图标可以使用 `commit = "HEAD"`

**版本固定方式**：
- `version = "v1.0.0"` - 语义化版本（推荐）
- `version = "v0.1.*"` - 通配符（自动获取补丁更新）
- `commit = "abc123"` - 锁定到具体提交（最稳定）
- `tag = "v1.0.0"` - 使用 git tag
- `branch = "main"` - 使用特定分支

### 6.4 备份与恢复

```bash
# 备份配置
tar czf nvim-backup-$(date +%Y%m%d).tar.gz ~/.config/nvim

# 备份插件版本锁定文件
cp ~/.config/nvim/lazy-lock.json ~/nvim-lazy-lock.bak

# 恢复到锁定版本
:Lazy restore
```

### 6.5 常见问题

**Q: 插件更新后出现错误怎么办？**
```vim
:Lazy restore  " 恢复到 lazy-lock.json 中的版本
```

**Q: LSP 不工作？**
```vim
:LspInfo       " 查看 LSP 状态
:checkhealth   " 检查配置
```

**Q: 键位冲突？**
```vim
:verbose map <key>  " 查看键位映射来源
```

**Q: 性能问题？**
```vim
:Lazy profile  " 查看插件加载时间
```

---

## 附录 A：完整插件列表

### A.1 LSP 与补全（9个）

| 插件 | 版本/Commit | 用途 |
|------|------|------|
| neovim/nvim-lspconfig | v0.1.* | LSP 配置引擎 |
| hrsh7th/nvim-cmp | v0.0.2 | 补全引擎 |
| hrsh7th/cmp-nvim-lsp | commit 99290b3 | LSP 补全源 |
| hrsh7th/cmp-buffer | commit b74fab3 | 缓冲区补全 |
| hrsh7th/cmp-path | commit c642487 | 路径补全 |
| hrsh7th/cmp-nvim-lua | commit f12408b | Lua API 补全 |
| saadparwaiz1/cmp_luasnip | commit 98d9cb5 | LuaSnip 补全源 |
| L3MON4D3/LuaSnip | v2.4.0 | 代码片段引擎 |
| onsails/lspkind-nvim | commit 3ddd1b4 | 补全菜单图标 |

### A.2 代码编辑与高亮（5个）

| 插件 | 版本/Commit | 用途 |
|------|------|------|
| jackguo380/vim-lsp-cxx-highlight | commit e0c749e | C/C++ 语义高亮 |
| fzhzhen1987/vim-gutentags | commit d411add | 自动 ctags/gtags |
| nvim-treesitter/nvim-treesitter | v0.9.2 | 语法树解析 |
| nvim-treesitter/nvim-treesitter-textobjects | commit 71385f1 | Treesitter 文本对象 |
| HiPhish/rainbow-delimiters.nvim | v0.10.0 | 彩虹括号 |

### A.3 编辑器增强（11个）

| 插件 | 版本/Commit | 用途 |
|------|------|------|
| nvim-lua/plenary.nvim | v0.1.4 | Lua 工具库 |
| yianwillis/vimcdoc | v2.5.0 | 中文文档 |
| jiangmiao/auto-pairs | v2.0.0 | 自动配对括号 |
| moll/vim-bbye | v1.0.1 | 智能关闭 buffer |
| azabiong/vim-highlighter | v1.63 | 高亮标记 |
| dominikduda/vim_current_word | commit 967c738 | 高亮当前词 |
| nathanaelkane/vim-indent-guides | commit a1e1390 | 缩进指南 |
| mg979/vim-visual-multi | v0.5.8 | 多光标编辑 |
| jiaoshijie/undotree | commit eab459a | 撤销历史树 |
| numToStr/Comment.nvim | v0.8.0 | 智能注释 |
| kylechui/nvim-surround | v3.1.6 | 包围符操作 |

### A.4 Git 集成（1个）

| 插件 | 版本/Commit | 用途 |
|------|------|------|
| airblade/vim-gitgutter | commit 488c055 | Git 差异显示 |

### A.5 工具与查找（7个）

| 插件 | 版本/Commit | 用途 |
|------|------|------|
| DreamMaoMao/yazi.nvim | commit 0e7dce1 | yazi 文件管理器集成 |
| iberianpig/tig-explorer.vim | commit ac49ff1 | tig Git TUI |
| Yggdroot/LeaderF | v1.25 | 模糊查找（gtags 集成） |
| kevinhwang91/nvim-bqf | v1.1.1 | QuickFix 增强 |
| nvim-telescope/telescope.nvim | v0.1.8 | 模糊查找系统 |
| nvim-telescope/telescope-fzf-native.nvim | commit 1f08ed6 | FZF 原生搜索 |
| nvim-telescope/telescope-live-grep-args.nvim | v1.1.0 | ripgrep 参数支持 |

### A.6 UI 与主题（5个）

| 插件 | 版本/Commit | 用途 |
|------|------|------|
| kristijanhusak/vim-hybrid-material | branch HEAD | hybrid_reverse 主题 |
| akinsho/bufferline.nvim | v3.7.0 | 顶部标签栏 |
| nvim-tree/nvim-web-devicons | branch HEAD | 文件图标 |
| nvim-lualine/lualine.nvim | compat-nvim-0.5 | 底部状态栏 |
| folke/which-key.nvim | commit 904308e | 键位提示 |

---

## 附录 B：完整键位映射

### B.1 禁用的键

| 键位 | 原功能 |
|------|--------|
| u | 撤销 |
| w | 单词前移 |
| l | 右移 |
| [[, ]], [], ][, [{, ]} | 原生方括号跳转 |
| {, } | 原生段落跳转 |

### B.2 光标移动

| 键位 | 功能 |
|------|------|
| Ctrl+p | 上移 (k) |
| Ctrl+n | 下移 (j) |
| Ctrl+b | 左移 (h) |
| Ctrl+f | 右移 (l) |
| Ctrl+a | 行首 |
| Ctrl+e | 行尾 |
| W | 向上 5 行 + 居中 |
| S | 向下 5 行 + 居中 |
| L | 向上滚动一行 |
| l | 向下滚动一行 |

### B.3 编辑操作

| 键位 | 功能 | 原键 |
|------|------|------|
| e | append | a |
| a | 单词前移 | b |
| d | 单词尾移 | e |
| j | 删除 | d |
| jj | 删除整行 | dd |
| Ctrl+j | 删除单词 (diw) | - |
| Ctrl+h | 删除前一字符 (X) | - |

### B.4 搜索跳转

| 键位 | 功能 |
|------|------|
| - | 向下查找当前单词 (*) |
| = | 向上查找当前单词 (#) |
| ' | 跳转匹配括号 (%) |

### B.5 代码块跳转

| 键位 | 功能 |
|------|------|
| [[ | 跳到外层块开始 |
| ]] | 跳到外层块结束 |
| { | 当前函数内跳到下一个 { |
| } | 当前函数内跳到下一个 } |

### B.6 文件操作

| 键位 | 功能 |
|------|------|
| Ctrl+s | 保存文件 |
| Ctrl+q | 退出 |
| Q | 保存并退出 |
| Alt+q | 退出所有 |
| Ctrl+q Ctrl+q | 强制退出 |
| F2 | 重载配置 |
| F3 | Lazy install |
| F4 | Lazy update |

### B.7 标签页与缓冲区

| 键位 | 功能 |
|------|------|
| wn | 新建标签页 |
| gn | 下一个标签页 |
| gp | 上一个标签页 |
| Shift+Tab | 关闭当前 buffer |
| Shift+x | 下一个 buffer |
| Shift+z | 上一个 buffer |

### B.8 窗口管理

| 键位 | 功能 |
|------|------|
| Space+wd/wa/ww/ws | 右/左/上/下分屏 |
| Space+wn | 新窗口 |
| Alt+d/w/a/s | 焦点向右/上/左/下 |
| Alt+Ctrl+w/s | 高度 +1/-1 |
| Alt+Ctrl+a/d | 宽度 -1/+1 |
| Space+we/wo | 垂直↔水平 / 水平↔垂直 |

### B.9 LSP 功能

| 键位 | 功能 |
|------|------|
| gd | 跳转到定义 |
| gD | 跳转到声明 |
| gi | 查找实现 |
| gt | 类型定义 |
| gr | 入调用（谁调用我） |
| go | 出调用（我调用谁） |
| gR | 查找所有引用 |
| gs | 当前文档符号 |
| gS | 工作区符号搜索 |
| J | LSP 悬浮文档 |
| ga | 代码操作/修复 |
| Space+rn | LSP 重命名 |
| Space+ch | 头/源文件切换 |
| Space+ci | Clangd 符号信息 |

### B.10 代码编辑

| 键位 | 功能 | 模式 |
|------|------|------|
| Space+c | 代码注释 | n/v |
| Space+gf | 代码格式化 | n |
| **Space+t** | **Surround 包围符操作** | **n/v** |
| Space+ta | 添加包围符（弹窗选择文本对象） | n |
| Space+tl | 当前行添加包围符 | n |
| Space+tA | 添加包围符（新行） | n |
| Space+tL | 当前行添加包围符（新行） | n |
| Space+tv | 添加包围符 | v |
| Space+tV | 添加包围符（新行） | v |
| Space+td | 删除包围符 | n |
| Space+tc | 修改包围符 | n |
| Space+tC | 修改包围符（新行） | n |

### B.11 搜索与诊断

| 键位 | 功能 |
|------|------|
| Space+gG | 全局内容搜索 |
| Space+gg | 搜索光标下的词 |
| Space+gq | 当前 buffer 诊断 |
| Space+gQ | 所有文件诊断 |
| Space+q | 切换 QuickFix |
| [q / ]q | 上/下一个 QuickFix 项 |
| Space+js | Leaderf 符号查询 |
| Space+jc | Leaderf 最近文件 |
| Space+jl | Leaderf 逐行搜索 |

### B.12 Git

| 键位 | 功能 |
|------|------|
| h | Git 预览修改块 |
| Space+gp | Git 上一个修改块 |
| Space+gn | Git 下一个修改块 |
| Space+gh | Git 切换行高亮 |

### B.13 Alt 组合键

| 键位 | 功能 |
|------|------|
| Alt+. | 跳转到定义（gtags） |
| Alt+, | 查找引用（gtags） |
| Alt+p | 召回上次查询 |
| Alt+/ | 当前 buffer 搜索 |
| Alt+r | 一键编译运行 |

### B.14 工具

| 键位 | 功能 |
|------|------|
| Space+ra | 打开 yazi 文件管理器 |
| Space+rt | 打开 Tig |
| Ctrl+r | 撤销历史树 |
| Space+m | 高亮当前单词 |
| Space+me | 删除高亮 |
| Space+M | 清除所有高亮 |
| Ctrl+k | 多光标（查找并添加） |

### B.15 其他

| 键位 | 功能 |
|------|------|
| ; | 进入命令模式 (:) |
| Ctrl+c | 复制到系统剪贴板（visual） |
| Ctrl+z | 删除行尾空格 |
| Space+Enter | 取消搜索高亮 |

---

**最后更新**: 2025-10-25
**作者**: fzh
**配置版本**: 1.1
