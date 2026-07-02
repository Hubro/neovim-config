local function teleport_closing_pair()
  local win, buf = 0, 0
  local cur = vim.api.nvim_win_get_cursor(win)
  local row, col = cur[1] - 1, cur[2] -- 0-based row and col indexes

  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1] or ""

  -- Grab the character to the right of the cursor
  local closer = line:sub(col + 1, col + 1)

  vim.treesitter.get_parser():parse()
  -- vim.wait(100)

  -- Find the first non-whitespace character after the cursor position
  local rest = line:sub(col + 2)
  local next = rest:find("%S") or 1
  local target_col = col + next

  -- require("hubro.debugprint")("{ rest }=" .. vim.inspect({ rest }))
  -- require("hubro.debugprint")("{ next }=" .. vim.inspect({ next }))
  -- require("hubro.debugprint")("{ { row, target_col } }=" .. vim.inspect({ { row, target_col } }))

  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row, target_col } })

  -- require("hubro.debugprint")("{ node:type() }=" .. vim.inspect({ node:type() }))
  -- require("hubro.debugprint")("{ node:range() }=" .. vim.inspect({ node:range() }))
  -- require("hubro.debugprint")("{ node:start() }=" .. vim.inspect({ node:start() }))
  -- require("hubro.debugprint")("{ node:end_() }=" .. vim.inspect({ node:end_() }))

  if not node then
    vim.notify("Couldn't find Tree-sitter node at " .. row .. ":" .. target_col, vim.log.levels.WARN)
    return
  end

  -- If the node is the start of a string, use the string node instead
  if node:parent() and node:parent():type() == "string" and select(3, node:parent():start()) == select(3, node:start()) then
    node = node:parent()
    assert(node)
  end

  -- Resolve the topmost parent of "node" that shares the same starting position
  -- while node:parent() and select(3, node:parent():start()) == select(3, node:start()) do
  --   node = node:parent()
  --   assert(node)
  -- end

  -- require("hubro.debugprint")("{ node:type() }=" .. vim.inspect({ node:type() }))
  -- require("hubro.debugprint")("{ node:range() }=" .. vim.inspect({ node:range() }))
  -- require("hubro.debugprint")("{ node:start() }=" .. vim.inspect({ node:start() }))
  -- require("hubro.debugprint")("{ node:end_() }=" .. vim.inspect({ node:end_() }))

  local _, _, end_row, end_col = node:range()
  vim.api.nvim_buf_set_text(buf, end_row, end_col, end_row, end_col, { closer })
  vim.api.nvim_win_set_cursor(win, { end_row + 1, end_col })

  -- Now delete the closer from its original position
  vim.api.nvim_buf_set_text(buf, row, col, row, col + 1, { "" })
end

-- vim.keymap.set("i", "<M-w>", function()
--   teleport_closing_pair()
-- end)

return teleport_closing_pair
