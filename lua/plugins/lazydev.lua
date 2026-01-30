return {
  "folke/lazydev.nvim",
  lazy = false,
  priority = 99999999,
  opts = {
    library = {
      "lazy.nvim",
      "LazyDev",
      "LazyVim",
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
