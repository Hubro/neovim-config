return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim"
  },
  config = function()
    local Snacks = require("snacks")
    local opencode = require("opencode")

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
    }

    -- Recommended/example keymaps.
    Snacks.keymap.set(
      { "n", "x" }, "<C-a>",
      function() opencode.ask("@this: ", { submit = true }) end,
      { desc = "Ask opencode…" })

    Snacks.keymap.set(
      { "n", "x" }, "<C-x>",
      function() opencode.select() end,
      { desc = "Execute opencode action…" })

    Snacks.keymap.set(
      { "n", "t" }, "<C-.>",
      function() opencode.toggle() end,
      { desc = "Toggle opencode" })

    Snacks.keymap.set(
      { "n", "x" }, "go",
      function() return opencode.operator("@this ") end,
      { desc = "Add range to opencode", expr = true })

    Snacks.keymap.set(
      "n", "goo",
      function() return opencode.operator("@this ") .. "_" end,
      { desc = "Add line to opencode", expr = true })

    Snacks.keymap.set(
      "n", "<S-C-u>",
      function() opencode.command("session.half.page.up") end,
      { desc = "Scroll opencode up" })

    Snacks.keymap.set(
      "n", "<S-C-d>",
      function() opencode.command("session.half.page.down") end,
      { desc = "Scroll opencode down" })

    -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
    Snacks.keymap.set(
      "n", "+", "<C-a>",
      { desc = "Increment under cursor", noremap = true })

    Snacks.keymap.set(
      "n", "-", "<C-x>",
      { desc = "Decrement under cursor", noremap = true })
  end,
}
