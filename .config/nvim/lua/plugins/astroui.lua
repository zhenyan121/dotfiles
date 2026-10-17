---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "astrodark",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = {
        Normal = { bg = "NONE", ctermbg = "NONE" },
        NormalNC = { bg = "NONE", ctermbg = "NONE" },
        NormalFloat = { bg = "NONE", ctermbg = "NONE" },
        FloatBorder = { bg = "NONE", ctermbg = "NONE" },
        FloatTitle = { bg = "NONE", ctermbg = "NONE" },
        FloatShadow = { bg = "NONE", ctermbg = "NONE" },
        FloatShadowThrough = { bg = "NONE", ctermbg = "NONE" },
        SignColumn = { bg = "NONE", ctermbg = "NONE" },
        FoldColumn = { bg = "NONE", ctermbg = "NONE" },
        Folded = { bg = "NONE", ctermbg = "NONE" },
        EndOfBuffer = { bg = "NONE", ctermbg = "NONE" },
        LineNr = { bg = "NONE", ctermbg = "NONE" },
        CursorLine = { bg = "NONE", ctermbg = "NONE" },
        CursorLineNr = { bg = "NONE", ctermbg = "NONE" },
        WinSeparator = { bg = "NONE", ctermbg = "NONE" },
        VertSplit = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeNormal = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeNormalNC = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeEndOfBuffer = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeWinSeparator = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabActive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabInactive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabSeparatorActive = { bg = "NONE", ctermbg = "NONE" },
        NeoTreeTabSeparatorInactive = { bg = "NONE", ctermbg = "NONE" },
        StatusLine = { bg = "NONE" },
        StatusLineNC = { bg = "NONE" },
        TabLine = { bg = "NONE" },
        TabLineFill = { bg = "NONE" },
        TabLineSel = { bg = "NONE" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
