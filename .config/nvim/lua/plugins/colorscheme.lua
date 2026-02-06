-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false, -- 我们希望启动就加载
    priority = 1000, -- 高优先级，确保先于其他插件加载
    config = function()
      vim.cmd.colorscheme("tokyonight-night") -- 加载后，立即设置这个主题
    end,
  }
}
