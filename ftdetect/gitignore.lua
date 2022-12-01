vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { ".gitignore", ".gitignore-*" },
  command = "set filetype=gitignore",
})
