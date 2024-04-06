return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "quangnguyen30192/cmp-nvim-ultisnips",
    "onsails/lspkind.nvim", -- LSP icons
  },
  config = function()
    vim.cmd [[ runtime setup_cmp.lua ]]
  end
}
