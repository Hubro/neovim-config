-- I'm sick of default Vim stuff taking presedence over my config even though
-- I'm using "after/ftplugin".
vim.defer_fn(function()
  -- Options
  vim.wo.colorcolumn = "89" -- Black's default line length + 1

  -- Tree-sitter folding
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
  vim.wo.foldlevel = 99

  -- Tree-sitter indentation
  vim.bo.indentexpr = nil
  vim.bo.indentkeys = "=elif,=else,=except"
end, 100)
