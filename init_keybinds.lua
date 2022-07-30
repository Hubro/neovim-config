
local default_opts = { noremap = true, silent = true }

local keybinds = {
  -- Use the plus key as an additional leader key, for keyboards that can't
  -- trivially produce a backslash (*cough* Macbooks)
  {"n", "+", "<Leader>", { noremap = false }},

  -- Alternative key to escape terminal, necessary since the original
  -- keybinding can't be expressed on a Mac keyboard
  {"t", "ń", "<C-\\><C-n>"},
  {"t", "Ǹ", "<C-\\><C-n>"},

  -- Press ESC to remove search highlights and clear text from command line
  {"n", "<Esc>", ":nohl<CR>:echo<Esc>"},

  -- Press Space to toggle folds
  {"n", "<Space>", "za"},
  {"n", "<S-Space>", "zA"},

  -- Move lines up/down
  {"n", "<A-k>", ":m -2<CR>"},
  {"n", "<A-j>", ":m +1<CR>"},

  -- Move selection up/down
  {"v", "<A-k>", ":m '<-2'<CR>gv"},
  {"v", "<A-j>", ":m '>+1'<CR>gv"},

  -- Indent/dedent selection without losing selection
  {"v", "<", "<gv"},
  {"v", ">", ">gv"},

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

  -- Quick horizontal window resizing using Alt + [><+-]
  {"n", "<M-lt>", "<"},
  {"n", "<M->>", ">"},
  {"n", "<M-+>", "+"},
  {"n", "<M-->", "-"},

  -- Pressing * in visual mode should search for the selected text, then select
  -- the next search result so * can be pressed repeatedly to move forwards.
  {"v", "*", '"sy/<C-r>s<CR>gn'},

  -- Pressing # in visual mode should do the same as *, but backwards.
  {"v", "#", '"sy?<C-r>s<CR>gn'},

  -- Text wrapping keybinds inspired by Sublime Text
  {"i", "<A-w>", "<Esc>0gqq0A"},   -- Wrap the current line while in insert mode
  {"i", "<A-q>", "<Esc>0V{gqA"},   -- Wrap the current paragraph in insert mode
  {"n", "<A-q>", "gqip"},          -- Wrap the current paragraph in normal mode

  -- Faster mouse scrolling while holding alt
  {"n", "<A-ScrollWheelUp>", "12<C-y>"},
  {"n", "<A-ScrollWheelDown>", "12<C-e>"},
  {"v", "<A-ScrollWheelUp>", "12<C-y>"},
  {"v", "<A-ScrollWheelDown>", "12<C-e>"},
  {"x", "<A-ScrollWheelUp>", "12<C-y>"},
  {"x", "<A-ScrollWheelDown>", "12<C-e>"},
  {"i", "<A-ScrollWheelUp>", "<C-o>12<C-y>"},
  {"i", "<A-ScrollWheelDown>", "<C-o>12<C-e>"},

  -- Horizontal mouse scrolling
  {"n", "<S-ScrollWheelUp>", "5zh"},
  {"n", "<S-ScrollWheelDown>", "5zl"},
  {"v", "<S-ScrollWheelUp>", "5zh"},
  {"v", "<S-ScrollWheelDown>", "5zl"},
  {"x", "<S-ScrollWheelUp>", "5zh"},
  {"x", "<S-ScrollWheelDown>", "5zl"},
  {"i", "<S-ScrollWheelUp>", "<C-o>5zh"},
  {"i", "<S-ScrollWheelDown>", "<C-o>5zl"},

  -- Faster horizontal mouse scrolling while holding alt
  {"n", "<A-S-ScrollWheelUp>", "15zh"},
  {"n", "<A-S-ScrollWheelDown>", "15zl"},
  {"v", "<A-S-ScrollWheelUp>", "15zh"},
  {"v", "<A-S-ScrollWheelDown>", "15zl"},
  {"x", "<A-S-ScrollWheelUp>", "15zh"},
  {"x", "<A-S-ScrollWheelDown>", "15zl"},
  {"i", "<A-S-ScrollWheelUp>", "<C-o>15zh"},
  {"i", "<A-S-ScrollWheelDown>", "<C-o>15zl"},

  -- GUI only keybinds (i.e. Neovide)
  {"i", "<C-V>", "<C-r>+"},   -- Ctrl+Shift+v, paste system clipboard

  --
  -- Plugin keybinds
  --

  -- Be quiet! Disable LSP diagnostics and ALE warnings
  {"n", "<Leader>q", ":ALEDisableBuffer<CR>:lua vim.diagnostic.disable(0)<CR>"},
  {"n", "<Leader>Q", ":ALEEnableBuffer<CR>:lua vim.diagnostic.enable(0)<CR>"},

  -- Some Fugitive shortcuts
  {"n", "<Leader>gs", ":tab G<CR>"},
  {"n", "<Leader>gl", ":tab Git log<CR>"},

  -- Jump to git hunk (gitsigns.nvim)
  {"n", "[c", ":silent :Gitsigns prev_hunk<CR>"},
  {"n", "]c", ":silent :Gitsigns next_hunk<CR>"},

  -- Git blame current lint (gitsigns.nvim)
  {"n", "<Leader>gb", ":silent :Gitsigns blame_line<CR>"},

  -- Telescope - Find files
  {"n", "<C-p>", ":Telescope find_files<CR>"},

  -- Telescope - File history
  {"n", "<C-A-p>", ":Telescope oldfiles<CR>"},
  {"n", "<Bar>h", ":Telescope oldfiles<CR>"},  -- Neovide can't do Ctrl+Alt yet...

  -- Telescope - Show document outline using LSP symbols
  {"n", "<Bar>o", ":Telescope lsp_document_symbols theme=outline<CR>"},

  -- Telescope - Show Ultisnips snippets
  {"n", "<Bar>s", ":Telescope ultisnips theme=ultisnips<CR>"},
  {"i", "<C-s>", "<Space><BS><Esc>:Telescope ultisnips theme=ultisnips<CR>"},

  -- Telescope - Live grep
  {"n", "<Bar>gr", ":Telescope live_grep<CR>"},

  -- Telescope - Git status
  {"n", "<Bar>gs", ":Telescope git_status<CR>"},

  -- Telescope - Show LSP code actions
  {"n", "<Bar>la", ":Telescope lsp_code_actions theme=get_dropdown<CR>"},

  -- Telescope - Show LSP references
  {"n", "<Bar>lr", ":Telescope lsp_references<CR>"},

  -- Toggle file tree (nvim-tree.lua)
  {"n", "<Leader>t", ":NvimTreeToggle<CR>"},
  {"n", "gt", ":NvimTreeFindFile<CR>"},   -- Open current file in the tree

  -- Toggle document outline (simrat39/symbols-outline.nvim)
  {"n", "<Leader>o", ":SymbolsOutline<CR>"},

  -- Toggle symbol outline
  --{"n", "<Leader>o", ":SymbolsOutline<CR>"},

  -- Zen mode
  {"n", "<F11>", ":silent :ZenMode<CR>"},

  -- Toggle light/dark mode
  {"n", "<F12>", ":lua toggle_colorscheme()<CR>"},

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

  {"n", "<F10>", ":Neoformat<CR>"},

  -- CTRL+Enter creates a new line below the current line, Shift+Enter creates
  -- a line above the current line. (These only work in GUIs.)
  {"i", "<C-CR>", "<Esc>o"},
  {"i", "<S-CR>", "<Esc>O"},

  -- Press Alt+N to go from block select mode to multiple cursors
  {"x", "<A-n>", "<Plug>(VM-Visual-Cursors)", { noremap = false }},

  -- Zoom in/out in a GUI (uses vim-gui-zoom plugin)
  {"n", "<C-+>", ":ZoomIn<CR>", { gui = true }},
  {"n", "<C-->", ":ZoomOut<CR>", { gui = true }},

  -- Set specific font sizes using Alt+1/2/3
  {"n", "<A-1>", ":lua vim.opt.guifont = vim.g.hubro_default_font<CR>"},
  {"n", "<A-2>", ":lua vim.opt.guifont = vim.g.hubro_big_font<CR>"},
  {"n", "<A-3>", ":lua vim.opt.guifont = vim.g.hubro_huge_font<CR>"},
}

-- Disable the bizarre default keymappings on Neovim 0.6
-- if vim.fn.has("nvim-0.6.0") == 1 then
--   -- This raises an error if the keybind is already deleted, so we ignore it
--   pcall(vim.api.nvim_del_keymap, "n", "Y")
-- end

-- {{{ The magic
function apply_keybinds(keybinds)
  for _, bind in ipairs(keybinds) do
    if #bind < 4 then
      bind[4] = default_opts
    else
      bind[4] = vim.tbl_extend("force", default_opts, bind[4])
    end

    if bind[4].mac then
      bind[4].mac = nil

      if vim.fn.has("macunix") == 0 then
        -- This is a mac-only keybind and this is not a MacOS system, so ignore
        -- this keybind
        goto continue
      end
    end

    if bind[4].gui then
      bind[4].gui = nil

      if vim.g.neovide ~= true then
        -- This is a GUI-only keybind, so if we're not running in Neovide,
        -- ignore this keybind
        goto continue
      end
    end

    vim.api.nvim_set_keymap(unpack(bind))

    ::continue::
  end
end

apply_keybinds(keybinds)
-- }}}
