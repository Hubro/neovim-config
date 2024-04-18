return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    cleanup_delay_ms = 120 * 1000, -- Wait 2 min before deleting hidden oil buffers
    keymaps = {
      ["<Tab>"] = "actions.preview",
      ["<C-x>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-p>"] = false,
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["yp"] = "actions.copy_entry_path",
      ["<Leader>yp"] = function() vim.cmd.normal('"+yp') end,
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    vim.keymap.set("n", "<Leader>-", ":e %:h<CR>")
  end
}
