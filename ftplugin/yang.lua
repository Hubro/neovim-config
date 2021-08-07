
-- YANG keywords can contain dashes
vim.opt.iskeyword:append("-")

-- Tree-sitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 100
