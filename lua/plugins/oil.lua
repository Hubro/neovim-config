return {
  "stevearc/oil.nvim",
  lazy = false,
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    cleanup_delay_ms = 120 * 1000, -- Wait 2 min before deleting hidden oil buffers
    keymaps = {
      ["π"] = "actions.preview", -- Altgr+P
      ["<C-x>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-p>"] = false,
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["gt"] = "actions.open_terminal",
    },
  },
  init = function()
    local actions = require("oil.actions")

    local yank_entry_path = function(opts)
      opts = opts or {}
      opts.absolute = opts.absolute or false;

      return function()
        if opts.absolute then
          actions.yank_entry.callback()
        else
          actions.yank_entry.callback({ modify = ":." })
        end

        print(
          "Copied path to register "
          .. vim.v.register
          .. ": "
          .. vim.fn.getreg(vim.v.register)
        )
      end
    end

    -- For some reason the keymaps option is really f***ing buggy so I'm
    -- setting them with an autocommand instead.
    local group = vim.api.nvim_create_augroup("OilCustomization", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "oil",
      callback = function()
        vim.keymap.set("n", "yp", yank_entry_path(), { buffer = true })
        vim.keymap.set("n", "yP", yank_entry_path({ absolute = true }), { buffer = true })
        vim.keymap.set("n", "<Leader>yp", '"+yp', { buffer = true, remap = true })
        vim.keymap.set("n", "<Leader>yp", '"+yP', { buffer = true, remap = true })
        vim.keymap.set("n", "<Leader>-", actions.parent.callback, { buffer = true })
      end
    })
  end,
  config = function(_, opts)
    require("oil").setup(opts)

    vim.keymap.set("n", "<Leader>-", ":e %:h<CR>")
  end
}
