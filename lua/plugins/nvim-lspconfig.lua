return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "SmiteshP/nvim-navic", -- Code position breadcrumbs status component
    "folke/lazydev.nvim",
  },
  lazy = false,
  config = function()
    local lsp_on_attach = require("hubro.lsp_on_attach")

    vim.lsp.config("*",
      {
        on_attach = lsp_on_attach,
        autostart = true,
      }
    )

    vim.lsp.enable({
      "robot_lsp",
      "homeassistant",
      "basedpyright",
      -- "pylsp",
      "ts_ls",
      "tailwindcss",
      "ruff",
      "lua_ls",
      "nixd",
      "efm",
      "yamlls",
      "clangd",
    })
  end,
}
