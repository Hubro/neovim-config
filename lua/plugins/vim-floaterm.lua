return {
  "voldikss/vim-floaterm",
  init = function()
    vim.g.floaterm_width = 0.8;
    vim.g.floaterm_height = 0.8;
  end,
  cmd = {
    "FloatermFirst",
    "FloatermPrev",
    "FloatermSend",
    "FloatermShow",
    "FloatermToggle",
    "FloatermNext",
    "FloatermLast",
    "FloatermNew",
    "FloatermHide",
    "FloatermKill",
    "FloatermUpdate",
  }
}
