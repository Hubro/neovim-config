-- Both Tree-sitter and default indent expressions suck shit
--vim.bo.indentexpr = nil
--vim.bo.indentexpr = "python#GetIndent(v:lnum)"
vim.bo.indentexpr = "nvim_treesitter#indent()"
vim.bo.indentkeys = "=elif,=else,=except"
