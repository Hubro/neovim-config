
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
      --local configs = require("nvim-treesitter.parsers").get_parser_configs()
      --
      -- configs.yang = {
      --     install_info = {
      --         url = "~/Dropbox/projects/tree-sitter-yang",
      --         files = { "src/parser.c" }
      --     },
      --     filetype = "yang",
      -- }

      require("nvim-treesitter.configs").setup {
        -- Value can be "all", "maintained" (parsers with maintainers), or a
        -- list of languages
        ensure_installed = {
          -- "abnf",
          "bash",
          "c",
          "css",
          "go",
          "graphql",
          "html",
          "java",
          "javascript",
          "lua",
          "php",
          "python",
          "query",
          "regex",
          "ruby",
          "rust",
          "scala",
          "scss",
          "toml",
          "typescript",
          "vue",
          "yaml",
          "yang",
        },

        highlight = {
          enable = true,
          -- Can also enable/disable for specific languages
          -- enable = { "python" },
          -- disable = { "c", "rust" },
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<A-9>",
            node_incremental = "<A-9>",
            -- scope_incremental = "<C-l>",
            node_decremental = "<A-8>",
          }
        },

        indent = {
          enable = true,
        },

        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        }
      }
    end
  }
  -- }}}

  -- {{{ vim-surround - Surround
  use "tpope/vim-surround"
  -- }}}

  -- {{{ editorconfig-vim - EditorConfig support
  use "editorconfig/editorconfig-vim"
  -- }}}

  -- {{{ vim-better-whitespace - Highlights and clears trailing whitespace
  vim.g.strip_whitespace_on_save = true
  vim.g.strip_whitelines_at_eof = true   -- Also strip trailing line endings
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
  use "SirVer/ultisnips"
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
        min_length = 1,

        source = {
          ultisnips = true,
          path = true,
          buffer = true,
          nvim_lsp = true,
        },
      }
    end
  }
  -- }}}

  -- {{{ nvim-lspconfig - Configurations for a bunch of language servers

  use {
    "neovim/nvim-lspconfig",
    config = function()
      if lsp_is_configured then
        return
      end

      _G.lsp_is_configured = true

      local lspconfig = require("lspconfig")
      local lspconfig_configs = require("lspconfig/configs")
      local lsputil = require("lspconfig/util")

      -- Runs when a buffer is connected to a language server
      --
      -- This function is defined globally so it can be reused in local config
      -- files (.nvimrc)
      --
      _G.pylsp_on_attach = function(client, bufnr)
        local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = {noremap=true, silent=true}

        map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        map('n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        map('n', '(', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        map('n', ')', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
      end

      -- Custom config for YANG language server
      --
      lspconfig_configs.yang_lsp = {
        default_config = {
          cmd = { "yang-language-server" },
          filetypes = { "yang" },
          root_dir = function(fname)
            return lsputil.root_pattern("yang.settings")(fname)

            -- return lsputil.find_git_ancestor(fname) or
            --   lsputil.root_pattern("yang.settings")(fname) or
            --   lsputil.path.dirname(fname)
          end,
        },
        docs = {
          description = [[
TODO
          ]],
        },
      }

      lspconfig.yang_lsp.setup {
        on_attach = _G.pylsp_on_attach,
      }

      lspconfig.pylsp.setup {
        on_attach = _G.pylsp_on_attach,
      }
    end
  }

  -- }}}

  ------------------
  -- Nice to have --
  ------------------

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
        mode = "lsp_document_diagnostics",
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
