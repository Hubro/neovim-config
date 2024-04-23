-- Document outline with LSP and Tree-sitter backends
return {
  "stevearc/aerial.nvim",
  dependencies = {
    "onsails/lspkind.nvim"
  },
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
      -- I've written the Aerial queries for these myself, so I want to show
      -- all symbol types
      yang = false,
      robot = false,
      nix = false,
    }
  },
}
