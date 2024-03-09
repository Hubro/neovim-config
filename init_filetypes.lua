--
-- Any filetypes that aren't automatically detected by Neovim
--

vim.filetype.add({
  extension = {
    -- extension = "filetype"
  },
  filename = {
    [".envrc"] = "bash",
    ["Tiltfile"] = "python",
    ["Justfile"] = "just",
    ["justfile"] = "just",
  },
  pattern = {
    ["%.gitconfig%-.*"] = "gitconfig",
    ["%.gitignore%-.*"] = "gitignore",
  },
})
