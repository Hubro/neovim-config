M = {}

---Buffer type
---@class Buffer
---@field bufnr number
---@field name string
---@field modified boolean

M.buffers = function()
  ---@type Buffer[]
  local buffers = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) == true then
      ---@type Buffer
      local buffer = {
        bufnr = bufnr,
        name = vim.api.nvim_buf_get_name(bufnr),
        modified = vim.api.nvim_get_option_value("modified", { buf = bufnr }),
      }
      table.insert(buffers, buffer)
    end
  end

  return buffers
end

M.workspace_is_empty = function()
  local buffers = M.buffers()

  return (
    #buffers == 1
    and buffers[1].name == ""
    and not buffers[1].modified
  )
end

-- Returns the directory of the buffer as a nice relative path
M.buf_dir = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Remove leading protocol (e.g. "oil://") if any
  filepath = string.gsub(filepath, "^%a+://", "")

  local is_dir = vim.fn.isdirectory(filepath) == 1
  local path

  if is_dir then
    path = filepath
  else
    path = vim.fn.fnamemodify(filepath, ":h")
  end

  -- Makes the path relative to CWD if possible. Otherwise makes it relative to
  -- "~/" if possible. Otherwise returns the absolute path.
  return vim.fn.fnamemodify(path, ":p:~:.") -- Make path relative to CWD
end

return M
