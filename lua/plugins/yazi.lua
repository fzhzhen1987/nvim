-- ~/.config/nvim/lua/plugins/yazi.lua
-- Yazi 文件管理器集成（使用浮动终端方案，兼容 Neovim 0.9+）

return {
  "DreamMaoMao/yazi.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  cmd = "Yazi",
  keys = {
    {
      "<leader>ra",
      "<cmd>Yazi<CR>",
      desc = "打开 yazi 浮动窗口",
    },
  },
}
