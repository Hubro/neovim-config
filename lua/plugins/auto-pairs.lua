-- Automatically close quotes and parentheses
return {
  "jiangmiao/auto-pairs",
  init = function()
    vim.g.AutoPairsShortcutToggle = ""
    vim.g.AutoPairsShortcutFastWrap = "<M-w>"
    vim.g.AutoPairsShortcutJump = ""
    vim.g.AutoPairsShortcutBackInsert = "<M-b>"
    vim.g.AutoPairsMultilineClose = 0 -- Never auto jump to next line
    vim.g.AutoPairsMapCh = 0          -- Don't map to <C-h>

    -- Center the viewport when pressing <CR> when near edge of viewport
    vim.g.AutoPairsCenterLine = 1
  end,
}
