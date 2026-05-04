return {
  "folke/lazydev.nvim",
  ft = "lua",
  enabled = true,
  opts = {
    library = {
      "lua",
      "lazy.nvim",
      "lazydev.nvim",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
