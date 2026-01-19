local function teleport_closing_pair()
  local win, buf = 0, 0
  local cur = vim.api.nvim_win_get_cursor(win)
  local row, col = cur[1] - 1, cur[2] -- 0-based row and col indexes

  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1] or ""

  local closer = line:sub(col + 1, col + 1)
  vim.api.nvim_buf_set_text(buf, row, col, row, col + 1, { "" })

  line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1] or ""
  local rest = line:sub(col + 1)
  local s = rest:find("%S")
  local target_col = col + (s or 0)

  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row, target_col } })

  if not node then
    vim.notify("Couldn't find Tree-sitter node at " .. row .. ":" .. target_col, "warning")
    return
  end

  -- Resolve the topmost parent of "node" that shares the same starting position
  while node:parent() and node:parent():start() == node:start() do
    node = node:parent()
    assert(node)
  end

  local _, _, end_row, end_col = node:range()
  vim.api.nvim_buf_set_text(buf, end_row, end_col, end_row, end_col, { closer })

  vim.api.nvim_win_set_cursor(win, { end_row + 1, end_col })
end

return teleport_closing_pair
