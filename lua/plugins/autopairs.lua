return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",

  -- Ref: https://github.com/windwp/nvim-autopairs?tab=readme-ov-file#default-values
  opts = {
  },

  -- From the old Vim plugin, for reference:
  --
  -- init = function()
  --   vim.g.AutoPairsShortcutToggle = ""
  --   vim.g.AutoPairsShortcutFastWrap = "<M-w>"
  --   vim.g.AutoPairsShortcutJump = ""
  --   vim.g.AutoPairsShortcutBackInsert = "<M-b>"
  --   vim.g.AutoPairsMultilineClose = 0 -- Never auto jump to next line
  --   vim.g.AutoPairsMapCh = 0          -- Don't map to <C-h>
  --   -- vim.g.AutoPairsMapCR = 0          -- Don't map Enter, it keeps fucking up the fucking Python indentation!!!

  --   -- Center the viewport when pressing <CR> when near edge of viewport
  --   vim.g.AutoPairsCenterLine = 0
  -- end,
}
