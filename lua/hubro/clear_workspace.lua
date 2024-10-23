---@class ClearWorkspaceOptions
---@field force boolean @Close all buffers and terminals, even if they are unsaved

---Closes all buffers in the workspace, leaving a blank canvas
---@param opts ClearWorkspaceOptions
local function clear_workspace(opts)
  opts.force = opts.force or false

  local bufs = vim.api.nvim_list_bufs()

  -- Check if any buffers are unsaved
  if not opts.force then
    for _, buf in ipairs(bufs) do
      if not vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
        goto continue
      end

      -- Stop if any buffers are unsaved
      if vim.api.nvim_get_option_value("modified", { buf = buf }) == true then
        vim.notify("One or more unsaved buffers", "WARNING")
        return
      end

      ::continue::
    end
  end

  -- Close everything!
  for _, buf in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(buf)

    -- Skip terminals for now
    if not opts.force and name:find("term://", 0, true) == 1 then
      goto continue
    end

    vim.api.nvim_buf_delete(buf, { force = opts.force })

    ::continue::
  end
end

return clear_workspace
