local function close_hidden_buffers()
  local visible_buffers = {}
  local closed = 0
  local terminals = 0

  -- Gather visible buffers
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      table.insert(visible_buffers, vim.api.nvim_win_get_buf(win))
    end
  end

  -- Close all non-visible buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local loaded = vim.api.nvim_buf_is_loaded(buf)
    local listed = vim.api.nvim_get_option_value("buflisted", { buf = buf })

    -- We only care about loaded and listed buffers, otherwise we'll constantly
    -- be closing a ton of background utility buffer
    if not (loaded and listed) then
      goto continue
    end

    if vim.tbl_contains(visible_buffers, buf) then
      goto continue
    end

    -- Also don't close buffer if it's unsaved
    if vim.api.nvim_get_option_value("modified", { buf = buf }) == true then
      goto continue
    end

    -- Also don't close any terminals
    if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal" then
      terminals = terminals + 1
      goto continue
    end

    -- print("KILLING BUFFER: " .. buf)
    -- print("BUFFER NAME: " .. vim.api.nvim_buf_get_name(buf))
    -- print("BUFFER BUFHIDDEN: " .. vim.inspect(vim.api.nvim_get_option_value("bufhidden", { buf = buf })))
    -- print("BUFFER BUFTYPE: " .. vim.inspect(vim.api.nvim_get_option_value("buftype", { buf = buf })))
    -- print("BUFFER SWAPFILE: " .. vim.inspect(vim.api.nvim_get_option_value("swapfile", { buf = buf })))
    -- print("BUFFER LISTED: " .. vim.inspect(vim.api.nvim_get_option_value("buflisted", { buf = buf })))
    -- print("BUFFER MODIFIABLE: " .. vim.inspect(vim.api.nvim_get_option_value("modifiable", { buf = buf })))
    -- print("BUFFER MODIFIED: " .. vim.inspect(vim.api.nvim_get_option_value("modified", { buf = buf })))
    -- print("BUFFER FILETYPE: " .. vim.inspect(vim.api.nvim_get_option_value("filetype", { buf = buf })))
    -- print("BUFFER READONLY: " .. vim.inspect(vim.api.nvim_get_option_value("readonly", { buf = buf })))

    vim.api.nvim_buf_delete(buf, {})
    closed = closed + 1

    ::continue::
  end

  local message = ""

  if closed > 0 then
    message = message .. "Closed " .. closed .. " hidden buffers"
  else
    message = message .. "No hidden buffers to close"
  end

  if terminals > 0 then
    message = message .. " (ignored " .. terminals .. " hidden terminals)"
  end

  print(message)
end

vim.api.nvim_create_user_command("CloseHiddenBuffers", close_hidden_buffers, {})
