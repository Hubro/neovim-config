return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()
  end,
  priority = 1000,   -- Other plugins might depend on packages installed by mason
  lazy = false,
}
