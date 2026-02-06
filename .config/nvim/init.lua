require("config.lazy")
-- 基础缩进设置
vim.opt.tabstop = 4      -- 1个Tab显示为4个空格
vim.opt.shiftwidth = 4   -- 自动缩进时缩进4个空格
vim.opt.expandtab = true -- 把Tab键变成空格（现代编程通用习惯）
vim.opt.softtabstop = 4  -- 编辑模式下按退格键退回4个空格
-- 显示行数
vim.opt.number = true
