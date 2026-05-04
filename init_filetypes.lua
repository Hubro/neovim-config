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
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
})

vim.filetype.add({
  extension = {
    ["xsh"] = 'xonsh',
    ["xonsh"] = 'xonsh',
  },
  content = { { pattern = '^#!.*\\<xonsh\\>' } }
})

-- Rust scripts (executable single-file Rust projects)
vim.filetype.add({
  pattern = {
    [".*"] = function(_, bufnr)
      local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
      if first_line:match("^#!.*%f[%w]rust%-script%f[%W]") then
        return "rust"
      elseif first_line:match("^#!.*%f[%w]scriptr%f[%W]") then
        return "rust"
      elseif first_line:match("^#!.*%f[%w]cargo%f[%W]") and first_line:match("%-Zscript") then
        return "rust"
      end
    end,
  },
})
