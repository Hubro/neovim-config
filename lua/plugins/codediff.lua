local function inject_custom_codediff_actions()
  local config = require("codediff.config")
  local explorer_keymaps = require("codediff.ui.explorer.keymaps")
  local lifecycle = require("codediff.ui.lifecycle")

  local setup_explorer_keymaps = explorer_keymaps.setup

  explorer_keymaps.setup = function(explorer)
    setup_explorer_keymaps(explorer)

    local mappings = config.options.keymaps.explorer
    local select_entry = vim.api.nvim_buf_call(explorer.split.bufnr, function()
      return vim.fn.maparg(mappings.select, "n", false, true).callback
    end)
    lifecycle.set_buf_keymap(explorer.tabpage, explorer.split.bufnr, "n", mappings.select_and_focus, function()
      local node = explorer.tree:get_node()
      select_entry()
      if node and node.data and node.data.type ~= "group" and node.data.type ~= "directory" then
        vim.schedule(function()
          local _, mod_win = lifecycle.get_windows(explorer.tabpage)
          if mod_win and vim.api.nvim_win_is_valid(mod_win) then
            vim.api.nvim_set_current_win(mod_win)
          end
        end)
      end
    end, { silent = true, nowait = true, desc = "Select entry and focus diff" }, { suspendable = false })
  end
end

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

    inject_custom_codediff_actions()

    codediff.setup({
      keymaps = {
        explorer = {
          select = "<Tab>",
          select_and_focus = "<CR>", -- Custom action
        },
      },
    })
  end,
  init = function()
    local Snacks = require("snacks")

    Snacks.keymap.set(
      { "n" }, "<Leader>gd", ":CodeDiff<CR>",
      { desc = "Summon CodeDiff" })
  end
}
