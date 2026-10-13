local diagnostics = require("hubro.diagnostics")

diagnostics.setup()

vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      if not diagnostics.is_suppressed(diagnostic) then
        return diagnostic.message
      end
    end,
  },
  -- virtual_lines = {
  --   severity = { min = vim.diagnostic.severity.INFO },
  -- },
  float = {
    suffix = function(diagnostic)
      return string.format(
        " [%s] (%s)",
        diagnostic.code,
        diagnostic.source
      ), ""
    end
  }
})

-- Enable / disable diagnostics
vim.keymap.set("n", "<Leader>s", ":lua vim.diagnostic.enable(false)<CR>")
vim.keymap.set("n", "<Leader>S", ":lua vim.diagnostic.enable(true)<CR>")
