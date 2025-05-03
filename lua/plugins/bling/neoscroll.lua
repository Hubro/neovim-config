return {
  "karb94/neoscroll.nvim",
  enabled = vim.g.neovide == nil,
  event = "VeryLazy",
  opts = {
    hide_cursor = true,
    easing_function = "quadratic",
    duration_multiplier = 0.7,
    mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
    pre_hook = function()
      -- require("treesitter-context").disable()
    end,
    post_hook = function()
      -- require("treesitter-context").enable()
    end,
  },
}
