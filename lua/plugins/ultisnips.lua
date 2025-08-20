return {
  "SirVer/ultisnips",
  event = "VeryLazy",
  cmd = { "UltiSnipsEdit", "UltiSnipsAddFiletypes" },
  keys = {
    { "<C-s>", "<Space><BS><Esc>:Telescope ultisnips theme=ultisnips<CR>", mode = "i", desc = "Insert snippet" }
  },
  init = function()
    vim.g.UltiSnipsEditSplit = "horizontal"

    -- Expansion is done by nvim-compe
    vim.g.UltiSnipsExpandTrigger = "<Plug>UltisnipsExpand"
  end,
}
