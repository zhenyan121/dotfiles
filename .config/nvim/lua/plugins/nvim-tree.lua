return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      -- 这里可以放自定义设置，初始用默认即可
    })
    -- 设置一个常用快捷键：空格+e 打开/关闭文件树
    -- 为 nvim-tree 设置一组实用快捷键
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
    vim.keymap.set('n', '<leader>f', function()
        local current_win = vim.api.nvim_get_current_win()
        local current_buf = vim.api.nvim_win_get_buf(current_win)
        local buf_ft = vim.api.nvim_buf_get_option(current_buf, 'filetype')
    
        if buf_ft == 'NvimTree' then
            -- 从文件树返回时，尝试回到之前编辑的窗口
            vim.cmd('wincmd p')
        
            -- 如果上一个窗口还是文件树（可能只有一个文件树窗口），就关闭它
            local new_win = vim.api.nvim_get_current_win()
            local new_buf = vim.api.nvim_win_get_buf(new_win)
            local new_buf_ft = vim.api.nvim_buf_get_option(new_buf, 'filetype')
        
            if new_buf_ft == 'NvimTree' then
                vim.cmd('NvimTreeClose')
            end
        else
            -- 保存当前窗口ID，以便从文件树返回时能准确回来
            vim.g.last_normal_win = current_win
            vim.cmd('NvimTreeFindFile')
        end
    end, { desc = '智能切换: 文件⇄树' })
    vim.keymap.set('n', '<leader>t', ':NvimTreeFocus<CR>', { desc = 'Focus on the file tree' }) 
  end,
}
