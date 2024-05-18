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
      vim.g.neovide_scale_factor = 1.3
    end,

    on_close = function()
      vim.g.neovide_scale_factor = 1
    end,
  },
  init = function()
    vim.keymap.set("n", "<F11>", function()
      require("zen-mode").toggle()
    end, {})
  end
}
