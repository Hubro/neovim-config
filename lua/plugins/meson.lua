return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      automatic_enable = false,
      ensure_installed = {
        "basedpyright",
        "lua_ls",
        "svelte",
        "tailwindcss",
        "ts_ls",
        "ty",
      },
    })
  end,
  priority = 1000, -- Other plugins might depend on packages installed by mason
  lazy = false,
}
