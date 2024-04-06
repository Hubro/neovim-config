return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "linrongbin16/lsp-progress.nvim",
    "SmiteshP/nvim-navic",        -- Code position breadcrumbs status component
    "ofseed/copilot-status.nvim", -- Shows what Copilot is up to
  },
  config = function()
    vim.cmd [[ runtime setup_lualine.lua ]]
  end
}
