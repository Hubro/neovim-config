return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {
    height = 20,
    auto_preview = false,
    keys = {
      zA = "fold_toggle",
      za = "fold_toggle",
      ["<Tab>"] = "jump",
      ["<CR>"] = "jump_close", -- Use <Tab> to jump without closing
    },
  },
  init = function()
    vim.keymap.set("n", "<Leader>td", ":Trouble diagnostics filter.severity=vim.diagnostic.severity.ERROR<CR>", {})
    vim.keymap.set("n", "<Leader>tD", ":Trouble diagnostics<CR>", {})
    vim.keymap.set("n", "<Leader>tq", ":Trouble quickfix<CR>", {})
  end
}
