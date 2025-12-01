-- Automatically close quotes and parentheses
return {
  "jiangmiao/auto-pairs",
  event = "VeryLazy",
  enabled = false, -- Stupid vim plugin that crashes randomly on Neovim
  init = function()
    vim.g.AutoPairsShortcutToggle = ""
    vim.g.AutoPairsShortcutFastWrap = "<M-w>"
    vim.g.AutoPairsShortcutJump = ""
    vim.g.AutoPairsShortcutBackInsert = "<M-b>"
    vim.g.AutoPairsMultilineClose = 0 -- Never auto jump to next line
    vim.g.AutoPairsMapCh = 0          -- Don't map to <C-h>
    -- vim.g.AutoPairsMapCR = 0          -- Don't map Enter, it keeps fucking up the fucking Python indentation!!!

    -- Center the viewport when pressing <CR> when near edge of viewport
    vim.g.AutoPairsCenterLine = 0
  end,
}
