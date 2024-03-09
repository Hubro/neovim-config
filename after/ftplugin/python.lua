local restore_view = require("hubro.restore_view")

-- Options
vim.wo.colorcolumn = "89" -- Black's default line length + 1

-- Tree-sitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99

-- Tree-sitter indentation
vim.bo.indentexpr = "nvim_treesitter#indent()"
vim.bo.indentkeys = "=elif,=else,=except"

-- Auto-formatting on save with Black
--
-- Actually, ruff does formatting now, and it's built-in to ruff-lsp! Get
-- fucked, Black!
--
--local aug = vim.api.nvim_create_augroup("PythonAutoFormat", { clear = false })
--vim.api.nvim_clear_autocmds({ group = aug, buffer = 0 })
--vim.api.nvim_create_autocmd("BufWritePre", {
--  group = aug,
--  buffer = 0,
--  callback = function()
--    restore_view(function() vim.cmd(":Black") end)
--  end,
--})
--
--vim.keymap.set("n", "<F10>", function()
--  restore_view(function() vim.cmd(":Black") end)
--end, { buffer = 0 })

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

vim.cmd(
  [[ command! PyflybyTidyImports :silent lua hubro_pyflyby_tidy_imports() ]]
)
