return {
  "SirVer/ultisnips",
  event = "VeryLazy",
  init = function()
    vim.g.UltiSnipsEditSplit = "horizontal"

    -- Expansion is done by nvim-compe
    vim.g.UltiSnipsExpandTrigger = "<Plug>UltisnipsExpand"
  end,
}
