-- 在你的 Lazy 插件配置文件中（例如：lua/plugins/cpp.lua）
return {
  {
    "jakemason/ouroboros",
    ft = { "c", "cpp", "h", "hpp" }, -- 可选：按文件类型懒加载
    dependencies = {
        "nvim-lua/plenary.nvim" -- 明确声明依赖[citation:8]
    },
    config = function()
      require("ouroboros").setup({
        -- 基本配置
        open_all_alternates = false,
        
        -- 查找策略（按顺序尝试）
        strategies = {
          "directory",    -- 同一目录
          "underscore",   -- main_window.cpp -> main_window.h
          "basename",     -- 相同基名
          "subdirectory", -- 在 include/ 或 src/ 中查找
          "cabal",        -- Cabal 项目结构
          "complement",   -- 互补扩展名
        },
        
        -- 扩展名映射
        extension_map = {
          h = { "cpp", "c", "cc", "cxx", "c++", "m", "mm" },
          hpp = { "cpp", "cc", "cxx", "c++" },
          hxx = { "cxx", "cpp" },
          hh = { "cc", "cpp" },
          c = { "h" },
          cc = { "h", "hh" },
          cpp = { "h", "hpp" },
          cxx = { "h", "hxx", "hpp" },
          m = { "h" },
          mm = { "h" },
        },
        
        -- 目录映射（适用于标准项目结构）
        directory_map = {
          ["include/(.*)%.h$"] = "src/%1.cpp",
          ["src/(.*)%.cpp$"] = "include/%1.h",
          ["inc/(.*)%.hpp$"] = "src/%1.cpp",
          ["lib/(.*)%.c$"] = "include/%1.h",
          ["source/(.*)%.cxx$"] = "headers/%1.hxx",
        },
        
        -- 自定义匹配函数
        match_callback = function(filepath, strategies, bufnr)
          -- 获取文件扩展名
          local extension = filepath:match("%.(%w+)$") or ""
          
          -- 如果是测试文件，寻找对应的源文件
          if filepath:match("_test%.cpp$") then
            local source_file = filepath:gsub("_test%.cpp$", ".cpp")
            if vim.fn.filereadable(source_file) == 1 then
              return { source_file }
            end
          end
          
          -- 返回默认策略
          return strategies
        end,
      })
      
      -- 键位映射
      vim.keymap.set("n", "<leader>oh", "<cmd>Ouroboros<cr>", {
        desc = "切换头文件/源文件",
        noremap = true,
        silent = true,
      })
      
      vim.keymap.set("n", "<leader>oa", "<cmd>OuroborosAll<cr>", {
        desc = "打开所有匹配文件",
        noremap = true,
        silent = true,
      })
      
      -- 可以添加更多命令
      vim.api.nvim_create_user_command("AltFile", function()
        require("ouroboros").switch()
      end, {})
    end,
  },
}
