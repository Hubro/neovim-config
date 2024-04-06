local scratch_split = require("hubro.scratch_split")

--- Prints a message to a debug buffer opened using "scratch_split".
---
--- If the split already exists, it's reused.
---
---@param message string
local function debugprint(message)
  local buf

  if _G.debugprint_buf ~= nil and vim.api.nvim_buf_is_loaded(_G.debugprint_buf) then
    buf = _G.debugprint_buf
  else
    buf = scratch_split({ split_name = "debugprint", focus = false })
    _G.debugprint_buf = buf
  end

  -- Split "message" into lines
  local lines = vim.split(message, "\n", { plain = true, trimempty = true })

  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })

  if vim.api.nvim_buf_line_count(buf) == 1 and #vim.api.nvim_buf_get_lines(buf, 0, -1, true)[1] == 0 then
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, lines)
  else
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, lines)
  end

  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

return debugprint
