vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { ".gitconfig", ".gitconfig-*" },
  command = "set filetype=gitconfig",
})
