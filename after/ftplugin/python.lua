-- Options
vim.wo.colorcolumn = "88" -- Black's default line length
vim.bo.indentkeys = "=elif,=else,=except"

-- Tree-sitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99

-- Tree-sitter indentation
vim.bo.indentexpr = "nvim_treesitter#indent()"

-- Custom key maps for vim-pythonsense
local map = function(keybind, command)
  vim.api.nvim_buf_set_keymap(0, "o", keybind, command, {})
  vim.api.nvim_buf_set_keymap(0, "v", keybind, command, {})
end
map("if", "<Plug>(PythonsenseInnerFunctionTextObject)")
map("af", "<Plug>(PythonsenseOuterFunctionTextObject)")
map("iC", "<Plug>(PythonsenseInnerClassTextObject)")
map("aC", "<Plug>(PythonsenseOuterClassTextObject)")
map("id", "<Plug>(PythonsenseInnerDocStringTextObject)")
map("ad", "<Plug>(PythonsenseOuterDocStringTextObject)")
map("]f", "<Plug>(PythonsenseStartOfNextPythonFunction)")
map("[f", "<Plug>(PythonsenseEndOfPreviousPythonFunction)")
map("]C", "<Plug>(PythonsenseStartOfNextPythonClass)")
map("[C", "<Plug>(PythonsenseEndOfPreviousPythonClass)")

-- Pyflyby commands
_G.hubro_pyflyby_tidy_imports = function()
  local lines_before = vim.fn.line("$")
  local cursor_pos = vim.fn.getpos(".")

  if vim.fn.executable("tidy-imports") ~= 1 then
    vim.api.nvim_err_writeln("Executable not found: tidy-imports")
    return
  end

  vim.cmd([[ %!tidy-imports --black --quiet ]])

  local lines_after = vim.fn.line("$")
  local line_diff = lines_after - lines_before

  -- Adjust cursor position for new line count
  cursor_pos[2] = cursor_pos[2] + line_diff

  vim.fn.setpos(".", cursor_pos)
end

vim.cmd([[ command! PyflybyTidyImports :silent lua hubro_pyflyby_tidy_imports() ]])
