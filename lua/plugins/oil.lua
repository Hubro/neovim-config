return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ["<C-x>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["yp"] = "actions.copy_entry_path",
      ["<Leader>yp"] = function() vim.cmd.normal('"+yp') end,
    },
  },
}
