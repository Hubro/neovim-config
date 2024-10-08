return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {
    height = 20,
    auto_preview = false,
    action_keys = {
      toggle_fold = { "zA", "za" },
      jump = { "<tab>" },
      jump_close = { "<cr>" }, -- Use <Tab> to jump without closing
    },
  },
  init = function()
    vim.keymap.set("n", "<Leader>td", ":Trouble diagnostics filter.severity=vim.diagnostic.severity.ERROR<CR>", {})
    vim.keymap.set("n", "<Leader>tD", ":Trouble diagnostics<CR>", {})
    vim.keymap.set("n", "<Leader>tq", ":Trouble quickfix<CR>", {})
  end
}
