return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 1. 初始化 Mason (包管理器)
      require("mason").setup({
        ui = { border = "rounded" }
      })

      -- 2. 配置 mason-lspconfig (自动安装LSP服务器)
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "lua_ls" },
        -- 【重要】新框架下，mason-lspconfig 会自动处理安装和配置
        -- 你不再需要手动调用 `require('lspconfig').xxx.setup()`
      })

      -- 3. 通用配置：快捷键与能力集
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        -- 按键映射
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      end

      -- 获取自动补全的能力集
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 4. 【核心修改】新版 LSP 配置框架
      -- 全局配置表，mason-lspconfig 会自动将这里定义的配置应用到对应服务器
      vim.lsp.config = vim.lsp.config or {}
      
      -- 导入工具函数（用于根目录检测）
      local util = require("lspconfig.util")

      -- ========== 配置 clangd (C/C++) ==========
      vim.lsp.config.clangd = {
        default_config = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--all-scopes-completion",
            "--cross-file-rename",
            "--completion-parse=auto"
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
          root_dir = function(fname)
            local root_markers = { '.git', 'compile_commands.json', 'compile_flags.txt', '.clangd', 'Makefile', 'build' }
            local root = util.root_pattern(unpack(root_markers))(fname)
            if not root then
              root = util.find_git_ancestor(fname) or vim.fs.dirname(fname)
            end
            return root
          end,
          single_file_support = true,
          capabilities = capabilities,
          on_attach = on_attach, -- 【重要】在这里绑定快捷键
        }
      }

      -- ========== 配置 lua_ls (Lua) ==========
      vim.lsp.config.lua_ls = {
        default_config = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
          capabilities = capabilities,
          on_attach = on_attach, -- 【重要】在这里绑定快捷键
        }
      }

      -- 5. 美化UI设置
      -- 悬浮文档窗口使用圆角边框
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "rounded",
        }
      )
      
      -- 【注意】在新框架下，通常不需要手动创建 LspAttach 自动命令
      -- 因为每个服务器的 on_attach 已在 default_config 中定义
      -- mason-lspconfig 会自动处理服务器启动和配置应用
    end,
  },

  -- 6. 自动补全配置 (nvim-cmp) - 保持不变，与新旧框架都兼容
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = { name = 'custom', selection_order = 'near_cursor' }
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
        })
      })
    end,
  },
}
