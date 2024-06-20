-- Nice LSP status and progress indicator for lualine
return {
  "linrongbin16/lsp-progress.nvim",
  lazy = true,
  opts = {
    spinner = { "", "", "", "", "", "" },
    spin_update_time = 75,
  },
}
