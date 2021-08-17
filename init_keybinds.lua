
local default_opts = { noremap = true, silent = true }

local keybinds = {
  -- Press ESC to remove search highlights and clear text from command line
  {"n", "<Esc>", ":nohl<CR>:echo<Esc>"},

  -- Press Space to toggle folds
  {"n", "<Space>", "za"},

  -- Move lines up/down
  {"n", "<A-k>", ":m -2<CR>"},
  {"n", "<A-j>", ":m +1<CR>"},

  -- Move selection up/down
  {"v", "<A-k>", ":m '<-2'<CR>gv"},
  {"v", "<A-j>", ":m '>+1'<CR>gv"},

  -- Easier window navigation
  {"n", "<C-h>", "<C-w>h"},
  {"n", "<C-j>", "<C-w>j"},
  {"n", "<C-k>", "<C-w>k"},
  {"n", "<C-l>", "<C-w>l"},

  -- Easier tab navigation
  {"n", "<A-l>", ":tabnext<CR>"},      -- Next tab
  {"n", "<A-h>", ":tabprev<CR>"},      -- Previous tab
  {"n", "<A-L>", ":tabmove +1<CR>"},   -- Move tab right
  {"n", "<A-H>", ":tabmove -1<CR>"},   -- Move tab left

  -- Telescope - Find files
  {"n", "<C-p>", ":Telescope find_files<CR>"},

  -- Telescope - File history
  {"n", "<C-A-p>", ":Telescope oldfiles<CR>"},

  -- Telescope - Show document outline using LSP symbols
  {"n", "<Bar>o", ":Telescope lsp_document_symbols theme=outline<CR>"},

  -- Telescope - Show Ultisnips snippets
  {"n", "<Bar>s", ":Telescope ultisnips theme=ultisnips<CR>"},
  {"i", "<C-s>", "<Space><BS><Esc>:Telescope ultisnips theme=ultisnips<CR>"},

  -- Toggle file tree (nvim-tree.lua)
  {"n", "<Leader>t", ":NvimTreeToggle<CR>"},
  {"n", "gt", ":NvimTreeFindFile<CR>"},   -- Open current file in the tree

  -- Toggle symbol outline
  --{"n", "<Leader>o", ":SymbolsOutline<CR>"},

  -- Show diagnostics window ("trouble.nvim" plugin)
  {"n", "<Leader>d", ":TroubleToggle<CR>"},
  {"n", ")", "<Plug>(ale_next_wrap)", { noremap = false }},
  {"n", "(", "<Plug>(ale_previous_wrap)", { noremap = false }},

  -- Floating terminal ("vim-floaterm" plugin)
  {"n", "<C-q>", ":FloatermToggle quick<CR>"},
  {"t", "<C-q>", "<C-\\><C-n>:FloatermToggle quick<CR>"},

  -- Open a new embedded terminal in a split
  {"n", "<F1>", ":vsplit<CR>:terminal<CR>i"},
  {"n", "<S-F1>", ":split<CR>:terminal<CR>i"},

  -- Wrap the current line while in insert mode
  {"i", "<A-q>", "<Esc>gqq0A"},

  -- CTRL+Enter creates a new line below the current line, Shift+Enter creates
  -- a line above the current line.
  {"i", "<C-CR>", "<Esc>o"},
  {"i", "<S-CR>", "<Esc>O"},
}

-- {{{ The magic
function apply_keybinds(keybinds)
  for _, bind in ipairs(keybinds) do
    if #bind < 4 then
      bind[4] = default_opts
    else
      bind[4] = vim.tbl_extend("force", default_opts, bind[4])
    end

    vim.api.nvim_set_keymap(unpack(bind))
  end
end

apply_keybinds(keybinds)
-- }}}
