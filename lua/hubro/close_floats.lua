-- Closes all non-focused floating windows
return function()
  local inactive_floating_wins = vim.fn.filter(
    vim.api.nvim_list_wins(),
    function(_, v)
      -- local buf = vim.api.nvim_win_get_buf(v)
      -- local file_type = vim.api.nvim_buf_get_option(buf, "filetype")

      return vim.api.nvim_win_get_config(v).relative ~= ""
        and v ~= vim.api.nvim_get_current_win()
    end
  )
  for _, w in ipairs(inactive_floating_wins) do
    pcall(vim.api.nvim_win_close, w, false)
  end
end
