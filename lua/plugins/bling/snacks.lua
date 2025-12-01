return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    input = { enabled = true },
    -- scroll = { enabled = vim.g.neovide == nil },
    indent = {
      enabled = true,
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
        style = "out",
        easing = "outSine", -- https://github.com/kikito/tween.lua?tab=readme-ov-file#easing-functions
        duration = {
          step = 20,        -- ms per step
          total = 200,      -- maximum duration
        },
      },
    },
    picker = {
      enabled = true,
    },
  },
}
