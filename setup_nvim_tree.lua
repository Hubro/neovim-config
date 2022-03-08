require("nvim-tree").setup {
  hijack_cursor = true,
  view = {
    width = 40
  },
  filters = {
    custom = {".git", "node_modules", "__pycache__"},
  }
}
