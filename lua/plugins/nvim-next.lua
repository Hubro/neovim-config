-- More powerful repeatable movements! (Improves ; and ,)
--
-- This plugin is fucking awesome, but because of a bug, it ruins repeating
-- actions with motions like "df".
--
-- Ref: https://github.com/ghostbuster91/nvim-next/issues/14
--
return {
  "ghostbuster91/nvim-next",
  enabled = false,
  event = "VeryLazy",
  config = function()
    local builtins = require("nvim-next.builtins")

    require("nvim-next").setup({
      default_mappings = {
        -- repeat_style = "directional", -- Overrides ; and ,
        repeat_style = "original", -- Overrides ; and ,
      },
      items = {
        builtins.f,
        builtins.t,
      },
    })
  end,
}
