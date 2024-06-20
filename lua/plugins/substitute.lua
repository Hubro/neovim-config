return {
  "gbprod/substitute.nvim",
  event = "VeryLazy",
  init = function()
    local sub = require("substitute")
    vim.keymap.set("n", "s", sub.operator)
    vim.keymap.set("n", "ss", sub.line)
    -- vim.keymap.set("n", "S", sub.eol)
    vim.keymap.set("x", "s", sub.visual)
  end,
  opts = {
    -- ...
  },
}
