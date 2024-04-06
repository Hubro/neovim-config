local augroup = vim.api.nvim_create_augroup("TerminalKeybinds", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_keymap("v", "<C-i>", '"xy"xpi', { noremap = true })
    vim.api.nvim_set_keymap("v", "<CR>", '<C-i><CR>', { noremap = false })
  end
})
