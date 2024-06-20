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
}
