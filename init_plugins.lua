
--
-- When this buffer is focused, press F5 to update plugins
--

vim.cmd [[
  augroup init_plugins.lua
    au!

    au BufReadPost init_plugins.lua set foldmethod=marker | set foldlevel=0
    au BufReadPost init_plugins.lua nnoremap <buffer> <F5> :so %<CR>:PackerSync<CR>
    au BufWritePost init_plugins.lua source <afile> | PackerCompile
  augroup end
]]

function init_plugins(use)
  use "wbthomason/packer.nvim"

  -------------------
  -- Core plugins ---
  -------------------

  -- {{{ Common dependencies

  -- plenary.nvim - Utilities for Lua scripting in Neovim
  use "nvim-lua/plenary.nvim"

  -- popup.vim -- Implementation of Vim's popup API in Neovim
  use "nvim-lua/popup.nvim"

  -- }}}

  -- {{{ nvim-treesitter - Tree-sitter support for Neovim
  use {
    -- "nvim-treesitter/nvim-treesitter",
    "Hubro/nvim-treesitter",

    requires = { "nvim-treesitter/playground" },

    config = function()
      vim.cmd "runtime configure_treesitter.lua"
    end
  }
  -- }}}

  -- {{{ vim-surround - Surround
  use "tpope/vim-surround"
  -- }}}

  -- {{{ vim-commentary - Comment / Uncomment
  use "tpope/vim-commentary"
  -- }}}

  -- {{{ editorconfig-vim - EditorConfig support
  use "editorconfig/editorconfig-vim"
  -- }}}

  -- {{{ vim-better-whitespace - Highlights and clears trailing whitespace
  vim.g.better_whitespace_enabled = false   -- Don't highlight whitespace
  vim.g.strip_whitespace_on_save = true
  vim.g.strip_whitelines_at_eof = true      -- Also strip trailing line endings
  vim.g.strip_whitespace_confirm = false
  use "ntpeters/vim-better-whitespace"
  -- }}}

  -- {{{ telescope.nvim - Fuzzy finder
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "fhill2/telescope-ultisnips.nvim"
    },
    config = function()
      vim.cmd "runtime configure_telescope.lua"
    end
  }
  -- }}}

  -- {{{ [DISABLED] fzf - Fuzzy File Finder inside Vim!
  -- vim.env.FZF_DEFAULT_OPTS = "--reverse --border --preview \"bat -p --color=always {}\""

  -- vim.g.fzf_layout = {
  --   window = {
  --     width = 200,
  --     height = 0.8,
  --     relative = false,
  --   }
  -- }

  -- use "junegunn/fzf"
  -- use "junegunn/fzf.vim"
  -- }}}

  -- {{{ vim-visual-multi - Multiple cursors
  use "mg979/vim-visual-multi"
  -- }}}

  -- {{{ vim-gitgutter - Show Git changes in gutter
  use "airblade/vim-gitgutter"
  -- }}}

  -- {{{ ultisnips - Snippet plugin
  vim.g.UltiSnipsEditSplit = "horizontal"
  vim.g.UltiSnipsExpandTrigger = "<Plug>UltisnipsExpand"   -- Expansion is done by nvim-compe

  use {
    "SirVer/ultisnips",
    opt = true,

    -- Only load ultisnips if Python 3 is available. Otherwise error messages
    -- pop up on every key press.
    cond = function()
      return vim.fn.has("python3") == 1
    end
  }
  -- }}}

  -- {{{ nvim-compe - Auto-completion plugin for Neovim
  use {
    "hrsh7th/nvim-compe",
    config = function()
      vim.o.completeopt = "menuone,noselect"

      -- https://github.com/hrsh7th/nvim-compe#lua-config
      require("compe").setup {
        enabled = true,
        autocomplete = true,
        preselect = "enable",
        min_length = 1,

        source = {
          ultisnips = true,
          path = true,
          buffer = true,
          nvim_lsp = true,
          nvim_lua = true,
        },
      }

      -- Completion menu ("nvim-compe" plugin)
      vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", {noremap = true, expr = true})
      vim.api.nvim_set_keymap("i", "<C-n>", "compe#complete()", {noremap = true, expr = true})
      vim.api.nvim_set_keymap(
        "i",
        "<Tab>",
        "compe#confirm({ 'keys': '<Tab>', 'select': v:true })",
        {noremap = true, expr = true}
      )
    end
  }
  -- }}}

  -- {{{ nvim-lspconfig - Configurations for a bunch of language servers

  use {
    "neovim/nvim-lspconfig",
    config = function()
      vim.cmd "runtime configure_lsp.lua"
    end
  }

  -- }}}

  -- {{{ ale - Asynchronous linter engine
  use {
    "dense-analysis/ale",
    config = function()
    end
  }
  -- }}}

  -- {{{ neoformat - Neovim plugin for formatting code
  vim.g.neoformat_enabled_javascript = { "prettier" }
  use "sbdchd/neoformat"
  -- }}}

  ----------------------
  -- Language support --
  ----------------------

  -- {{{ Robot Framework
  --
  -- LSP config for Robot Framework is done in the LSP configuration above
  --

  -- Syntax highlighting
  use "mfukar/robotframework-vim"

  -- }}}

  -- {{{ Python

  -- https://github.com/Vimjas/vim-python-pep8-indent#gpython_pep8_indent_multiline_string
  vim.g.python_pep8_indent_multiline_string = -2

  -- Better indentation expression (indentexpr) for Python
  use "Vimjas/vim-python-pep8-indent"

  -- }}}

  ------------------
  -- Nice to have --
  ------------------

  -- {{{ lazygit.nvim - Lazygit inside neovim
  use "kdheepak/lazygit.nvim"
  -- }}}

  -- {{{ nvim-tree.lua - File explorer
  vim.g.nvim_tree_width = 40

  use "kyazdani42/nvim-tree.lua"
  -- }}}

  -- {{{ trouble.nvim - A pretty list for showing diagnostics, quickfix etc.
  use {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        height = 20,
        mode = "loclist",
        auto_preview = false,
        action_keys = {
          toggle_fold = {"zA", "za", "<Space>"},
        },
      }
    end
  }
  -- }}}

  -- {{{ vim-floaterm - Floating terminal
  vim.g.floaterm_autoclose = 2
  vim.g.floaterm_width = 120
  vim.g.floaterm_height = 50

  use "voldikss/vim-floaterm"
  -- }}}

  ------------
  -- Bling ---
  ------------

  -- {{{ Icons - Needed by multiple plugins
  use "kyazdani42/nvim-web-devicons"
  use "ryanoasis/vim-devicons"
  -- }}}

  -- {{{ lualine.nvim - Fast statusline for Neovim written in Lua
  use {
    "hoob3rt/lualine.nvim",
    config = function()
      require("plenary.reload").reload_module("lualine", true)
      require("lualine").setup {
        options = {
          theme = "gruvbox"
        }
      }
    end
  }
  -- }}}

  -------------------
  -- Color schemes --
  -------------------

  vim.g.one_allow_italics = 1   -- Allow italics in One theme

  use "rakr/vim-one"                -- One theme (dark and light)
  use "tomasr/molokai"              -- Molokai
  use "arcticicestudio/nord-vim"    -- Nord
  use "cocopon/iceberg.vim"         -- Iceberg
  use "morhetz/gruvbox"             -- Gruvbox
  use "ayu-theme/ayu-vim"           -- Ayu
  use "folke/tokyonight.nvim"       -- TokyoNight
end

require("packer").startup {
  init_plugins,
  config = {
    display = {
      -- Display packer output window as a floating window
      open_fn = require("packer.util").float,
    }
  }
}

--
-- Automatically install all plugins if they are missing
--

local compiled_plugin_path =
  vim.fn.stdpath("config") ..  "/plugin/packer_compiled.lua"

if vim.fn.filereadable(compiled_plugin_path) ~= 1 then
  _G.initial_packer_compile_done = function()
    vim.cmd [[ au! User PackerCompileDone ]]

    set_default_colorscheme()
  end

  vim.cmd [[
    au User PackerCompileDone lua initial_packer_compile_done()

    PackerSync
  ]]
else
  -- Always rebuild plugins on startup, otherwise Packer will raise errors when
  -- switching between platforms (Linux, Windows, macOS).
  vim.cmd "PackerCompile"
end
