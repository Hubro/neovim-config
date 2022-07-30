
-- YANG keywords can contain dashes
vim.opt.iskeyword:append("-")

-- Tree-sitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 0

-- Tree-sitter indentation
vim.bo.indentexpr = "nvim_treesitter#indent()"

-- Recompute folds after opening a YANG file, works around this Telescope
-- bug: https://github.com/nvim-telescope/telescope.nvim/issues/699
--vim.cmd [[ au BufEnter *.yang :norm zX<CR> ]]

vim.b.ale_linters = { "yang-custom" }
