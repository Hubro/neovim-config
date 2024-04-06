return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "ghostbuster91/nvim-next",
  },
  setup = function()
    vim.cmd [[ runtime setup_treesitter.lua ]]
  end
}
