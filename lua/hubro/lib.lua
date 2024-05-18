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

return M
