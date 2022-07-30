--
-- Until TJ Devries adds jsonnet to nvim-treesitter
--
-- https://github.com/sourcegraph/tree-sitter-jsonnet
--
vim.cmd[[
  au BufNewFile,BufRead *.jsonnet set filetype=javascript
]]
