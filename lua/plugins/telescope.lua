return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "fhill2/telescope-ultisnips.nvim",
  },
  config = function()
    vim.cmd [[ runtime setup_telescope.lua ]]
  end,
}
