return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    keymaps = {
      ["<C-x>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-h>"] = false,
      ["<C-l>"] = false,
    },
  },
}
