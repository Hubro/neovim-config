return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      width = 140,
    },

    options = {
      signcolumn = "no",
    },

    plugins = {
      gitsigns = { enabled = false },
    },

    on_open = function(win)
      -- TODO
    end,

    on_close = function()
      -- TODO
    end,
  },
  init = function()
    vim.keymap.set("n", "<F11>", function()
      require("zen-mode").toggle()
    end, {})
  end
}
