return {
  "ggandor/leap.nvim",
  config = function()
    vim.keymap.set({ "n", "x", "o" }, "å", "<Plug>(leap-forward-to)")
    vim.keymap.set({ "n", "x", "o" }, "Å", "<Plug>(leap-backward-to)")
    vim.keymap.set({ "n", "x", "o" }, "gå", "<Plug>(leap-cross-window)")
  end,
}
