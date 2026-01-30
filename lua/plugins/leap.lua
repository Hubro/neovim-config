return {
  "https://codeberg.org/andyg/leap.nvim",
  init = function()
    vim.keymap.set({ "n", "x", "o" }, "å", "<Plug>(leap-forward)")
    vim.keymap.set({ "n", "x", "o" }, "Å", "<Plug>(leap-backward)")
    vim.keymap.set({ "n", "x", "o" }, "gå", "<Plug>(leap-anywhere)")
  end,
}
