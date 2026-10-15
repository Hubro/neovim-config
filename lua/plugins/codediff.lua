return {
  "esmuellert/codediff.nvim",
  dependencies = {
    "folke/snacks.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  cmd = "CodeDiff",
  config = function()
    local codediff = require("codediff")
    local keymaps = require("codediff.ui.view.keymaps")
    local layout = require("codediff.ui.layout")
    local lifecycle = require("codediff.ui.lifecycle")
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    local hunk = ts_repeat_move.make_repeatable_move(function(opts)
      if opts.forward then
        codediff.next_hunk()
      else
        codediff.prev_hunk()
      end
    end)

    -- Wrap and replace codediff's keymaps functions so we can add custom ones
    local setup_all_keymaps = keymaps.setup_all_keymaps

    keymaps.setup_all_keymaps = function(tabpage, ...)
      setup_all_keymaps(tabpage, ...)

      lifecycle.set_tab_keymap(tabpage, "n", "]c", function() hunk({ forward = true }) end,
        { desc = "Next hunk" })
      lifecycle.set_tab_keymap(tabpage, "n", "[c", function() hunk({ forward = false }) end,
        { desc = "Previous hunk" })
    end

    -- Disable auto-resizing of windows, which makes keeping opencode on the
    -- side possible
    local arrange = layout.arrange
    layout.arrange = function(tabpage)
      local session = lifecycle.get_session(tabpage)
      if session and session.single_pane then
        return
      end
      return arrange(tabpage)
    end

    codediff.setup({})
  end,
  init = function()
    local Snacks = require("snacks")

    Snacks.keymap.set(
      { "n" }, "<Leader>gd", ":CodeDiff<CR>",
      { desc = "Summon CodeDiff" })
  end
}
