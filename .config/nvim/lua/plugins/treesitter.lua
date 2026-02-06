return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- 建议使用 master 分支
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" }, -- 只有打开文件时才加载，防止启动报错
  config = function()
    -- 增加一个保护性检测
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end

    configs.setup({
      ensure_installed = { "lua", "vim", "vimdoc", "query", "c", "cpp" }, -- 基础必装
      highlight = { enable = true },
      indent = { enable = true }, -- 建议开启，C++ 缩进会更准确
    })
  end,
}
