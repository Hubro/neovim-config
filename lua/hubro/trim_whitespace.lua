local function trim_whitespace()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  require("hubro.debugprint")("{ lines }=" .. vim.inspect({ lines }))

  for i, line in ipairs(lines) do
    local last_char = line:sub(-1)

    if last_char == " " or last_char == "\t" then
      lines[i] = line:gsub("%s+$", "")
    end
  end

  -- Trim any empty lines at the end of the file
  while #lines > 0 and lines[#lines] == "" do
    table.remove(lines)
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

return trim_whitespace
