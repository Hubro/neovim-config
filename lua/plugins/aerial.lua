-- Document outline with LSP and Tree-sitter backends
return {
  "stevearc/aerial.nvim",
  opts = {
    backends = { "treesitter", "lsp", "markdown" },
    layout = {
      max_width = { 80, 0.9 },
      min_width = 60,
    },
    keymaps = {
      ["<Esc>"] = "actions.close",
    },
    close_on_select = true,
    float = {
      relative = "win",
    },
    link_tree_to_folds = false,
    link_folds_to_tree = false,
    show_guides = true,
    nerd_font = true,
    filter_kind = {
      yang = false,  -- In YANG, show all symbol types
      robot = false, -- In Robot Framework, show all symbol types
    }
  },
}
