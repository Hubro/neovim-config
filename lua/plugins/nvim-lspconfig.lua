return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "SmiteshP/nvim-navic",   -- Code position breadcrumbs status component
    "folke/neodev.nvim",     -- Lua LSP overrides for working with Neovim
  },
  config = function()
    vim.cmd([[ runtime setup_lsp.lua ]])
  end,
}
