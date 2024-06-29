local function clear_workspace()
  local bufs = vim.api.nvim_list_bufs()

  -- Check if any buffers are unsaved
  for _, buf in ipairs(bufs) do
    if not vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
      goto continue
    end

    -- Stop if any buffers are unsaved
    if vim.api.nvim_get_option_value("modified", { buf = buf }) == true then
      vim.notify("One or more unsaved buffers", { level = "ERROR" })
      return
    end

    ::continue::
  end

  -- Close everything!
  for _, buf in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(buf)

    -- Skip terminals for now
    if name:find("term://", 0, true) == 1 then
      goto continue
    end

    vim.api.nvim_buf_delete(buf, {})

    ::continue::
  end
end

return clear_workspace
