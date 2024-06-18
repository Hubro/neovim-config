-- Options
vim.wo.colorcolumn = "89" -- Black's default line length + 1

-- Tree-sitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99
