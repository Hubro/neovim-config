
-- Options
vim.wo.colorcolumn = "80"

-- Tree-sitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 0

-- Recompute folds after opening a Python file, works around this Telescope
-- bug: https://github.com/nvim-telescope/telescope.nvim/issues/699
--vim.cmd [[ au BufEnter *.py :norm zX<CR> ]]

-- Pyflyby commands
_G.hubro_pyflyby_tidy_imports = function()
  local lines_before = vim.fn.line("$")
  local cursor_pos = vim.fn.getpos(".")

  if vim.fn.executable("tidy-imports") ~= 1 then
    vim.api.nvim_err_writeln("Executable not found: tidy-imports")
    return
  end

  vim.cmd [[ %!tidy-imports --black --quiet ]]

  local lines_after = vim.fn.line("$")
  local line_diff = lines_after - lines_before

  -- Adjust for new line count
  cursor_pos[2] = cursor_pos[2] + line_diff

  vim.fn.setpos(".", cursor_pos)
end

vim.cmd [[ command! PyflybyTidyImports :silent lua hubro_pyflyby_tidy_imports() ]]
