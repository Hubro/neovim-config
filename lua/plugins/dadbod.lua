return {
  "tpope/vim-dadbod",
  dependencies = { "kristijanhusak/vim-dadbod-ui", lazy = true },
  cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
