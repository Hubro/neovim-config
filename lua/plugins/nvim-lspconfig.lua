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
    }

    for _, value in ipairs(my_lsps) do
      vim.lsp.config(
        value,
        { on_attach = lsp_on_attach, autostart = true }
      )
    end

    vim.lsp.enable(my_lsps)

    -- My Tree-sitter parser for roboot files doesn't handle variables embedded
    -- in keywords, so I'm overriding the syntax highlighting of keywords using
    -- the LSP semantic token for now. See :Inspect.
    vim.api.nvim_set_hl(0, "@lsp.type.keywordNameCall.robot", { link = "Function" })
  end,
}
