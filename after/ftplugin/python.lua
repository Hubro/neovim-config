-- Options
vim.wo.colorcolumn = "89" -- Black's default line length + 1

-- Tree-sitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99

local function toggle_fstring()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if not node then return end

  --- @type TSNode?
  local string_node = nil

  while node do
    if node:type() == "string" then
      string_node = node
      break
    end

    node = node:parent()
  end
  if not string_node then return end

  local string_start = string_node:child(0)
  local delimiter = vim.treesitter.get_node_text(string_start, 0)
  local row, col = string_start:start()

  if delimiter:find("f") == 1 then
    vim.api.nvim_buf_set_text(0, row, col, row, col + 1, {})
  else
    vim.api.nvim_buf_set_text(0, row, col, row, col, { "f" })
  end
end

vim.keymap.set("i", "<C-f>", toggle_fstring, { buffer = true })
vim.keymap.set("n", "<Leader>f", toggle_fstring, { buffer = true })
