return {
  "karb94/neoscroll.nvim",
  enabled = vim.g.neovide == nil,
  event = "VeryLazy",
  opts = {
    hide_cursor = true,
    easing_function = "quadratic",
    pre_hook = function()
      -- require("treesitter-context").disable()
    end,
    post_hook = function()
      -- require("treesitter-context").enable()
    end,
  },
  config = function(_, opts)
    require("neoscroll").setup(opts)
    require("neoscroll.config").set_mappings({
      ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "150" } },
      ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "150" } },
      ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "200" } },
      ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "200" } },
    })
  end
}
