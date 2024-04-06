local aug = vim.api.nvim_create_augroup("ColorColumn", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = aug,
  callback = function()
    if vim.wo.cc == "" and vim.bo.textwidth ~= 0 then
      -- Default colorcolumn to textwidth +1. This makes the default
      -- colorcolumn work nicely with textwidth set by editorconfig.
      vim.wo.cc = "+1"
    end
  end
})
