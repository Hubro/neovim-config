-- Both Tree-sitter and default indent expressions suck shit
vim.bo.indentexpr = nil
vim.bo.indentkeys = "=elif,=else,=except"
