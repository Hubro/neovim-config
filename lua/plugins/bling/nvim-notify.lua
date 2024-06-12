return {
  "rcarriga/nvim-notify",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- For :Telescope notify
  },
  config = function()
    local notify = require("notify")

    ---@diagnostic disable-next-line: missing-fields
    notify.setup({
      render = "wrapped-compact",
      stages = "slide",
      top_down = false,
    })

    local banned_messages = {
      "No information available",
    }

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(msg, ...)
      for _, banned in ipairs(banned_messages) do
        if msg == banned then
          return
        end

        return notify(msg, ...)
      end
    end
  end,
}
