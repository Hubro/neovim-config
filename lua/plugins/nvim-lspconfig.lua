return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "SmiteshP/nvim-navic", -- Code position breadcrumbs status component
    "folke/lazydev.nvim",
  },
  lazy = false,
  config = function()
    local lsp_on_attach = require("hubro.lsp_on_attach")

    local my_lsps = {
      "robotframework_ls",
      -- "homeassistant",
      "basedpyright",
      -- "pylsp",
      "ts_ls",
      "tailwindcss",
      "svelte",
      "ruff",
      "lua_ls",
      "nixd",
      "efm",
      "yamlls",
      "clangd",
      "nu",
      -- "rust-analyzer",   -- Managed by rustaceanvim
      "taplo", -- For TOML files
      "ty",    -- Python LSP of the future
    }

    for _, value in ipairs(my_lsps) do
      vim.lsp.config(
        value,
        { on_attach = lsp_on_attach, autostart = true }
      )
    end

    vim.lsp.enable(my_lsps)

    -- Use ty by default. Override per project with `vim.lsp.enable`.
    vim.lsp.enable("basedpyright", false)
  end,
}
