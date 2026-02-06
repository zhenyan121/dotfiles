return {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- 只有进入插入模式时才加载，节省性能
    config = true -- 相当于调用 require("nvim-autopairs").setup({})
}
