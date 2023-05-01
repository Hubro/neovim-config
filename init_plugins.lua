local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

function setup_file(name)
  return function()
    vim.cmd("runtime setup_" .. name .. ".lua")
  end
end

require("lazy").setup({

  -- =============================
  -- === Absolute core plugins ===
  -- =============================

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = setup_file("treesitter"),
    -- setup = function()
    --   vim.cmd[[ runtime setup_treesitter.lua ]]
    -- end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-lua/lsp-status.nvim", -- LSP status component
      "SmiteshP/nvim-navic", -- Code position breadcrumbs status component
      "folke/neodev.nvim", -- Lua LSP overrides for working with Neovim
    },
    config = function()
      vim.cmd([[ runtime setup_lsp.lua ]])
    end,
  },

  -- Mandatory tpope goodness
  "tpope/vim-repeat", -- Allows plugins to implement proper repeat support
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-sleuth", -- Smartly detect shiftwidth and related settings
  "tpope/vim-eunuch", -- Adds common Unix command helpers like ":Rename"

  -- EditorConfig support
  "editorconfig/editorconfig-vim",

  -- Multiple cursors
  "mg979/vim-visual-multi",

  -- More powerful repeatable movements! (Improves ; and ,)
  -- {
  --   "ghostbuster91/nvim-next",
  --   config = function()
  --     local builtins = require("nvim-next.builtins")

  --     require("nvim-next").setup({
  --       default_mappings = true, -- Overrides ; and ,
  --       repeat_style = "directional",
  --       items = {
  --         builtins.f,
  --         builtins.t,
  --       },
  --     })
  --   end,
  -- },

  -- Automatically close quotes and parentheses
  {
    "jiangmiao/auto-pairs",
    init = function()
      vim.g.AutoPairsShortcutToggle = ""
      vim.g.AutoPairsShortcutFastWrap = "<M-w>"
      vim.g.AutoPairsShortcutJump = ""
      vim.g.AutoPairsShortcutBackInsert = "<M-b>"
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "fhill2/telescope-ultisnips.nvim",
    },
    config = setup_file("telescope"),
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    config = function(harpoon)
      local h_mark = require("harpoon.mark")
      local h_ui = require("harpoon.ui")

      vim.keymap.set({ "n" }, "<Leader>.", h_mark.add_file)
      vim.keymap.set({ "n" }, "<Leader>h", h_ui.toggle_quick_menu)
      vim.keymap.set({ "n" }, "<Leader>j", h_ui.nav_next)
      vim.keymap.set({ "n" }, "<Leader>k", h_ui.nav_prev)
    end,
  },

  -- Document outline with LSP and Tree-sitter backends
  {
    "stevearc/aerial.nvim",
    opts = {
      backends = { "treesitter", "lsp", "markdown" },
      layout = {
        max_width = { 80, 0.9 },
        min_width = 60,
      },
      keymaps = {
        ["<Esc>"] = "actions.close",
      },
      close_on_select = true,
      float = {
        relative = "win",
      },
    },
  },

  -- Asynchronous linter engine
  {
    "dense-analysis/ale",
    init = function()
      vim.g.ale_linters_explicit = "1" -- Only run stuff I explicitly enable
      vim.g.ale_disable_lsp = "1"
    end,
  },

  -- Snippet support
  {
    "SirVer/ultisnips",
    init = function()
      vim.g.UltiSnipsEditSplit = "horizontal"

      -- Expansion is done by nvim-compe
      vim.g.UltiSnipsExpandTrigger = "<Plug>UltisnipsExpand"
    end,
  },

  -- Auto-completion dropdown
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "onsails/lspkind.nvim", -- LSP icons
    },
    config = setup_file("cmp"),
  },

  -- Extensible plugin for auto-formatting code
  { "mhartington/formatter.nvim", config = setup_file("formatter") },

  -- ========================
  -- === Nice extra tools ===
  -- ========================

  -- Copilot (Remember to run ":Copilot setup" to sign in)
  {
    "github/copilot.vim",
    config = function()
      -- Keep copilot disabled, only invoke explicitly
      vim.g.copilot_filetypes = { ["*"] = false }

      -- Don't map to the tab key
      vim.g.copilot_no_tab_map = true

      vim.keymap.set("n", "<Leader>cp", ":Copilot panel<CR>", { silent = true })
      vim.keymap.set("i", "<A-p>", "<Plug>(copilot-suggest)", { silent = true })
      vim.keymap.set("i", "<A-j>", "<Plug>(copilot-next)", { silent = true })
      vim.keymap.set(
        "i",
        "<A-k>",
        "<Plug>(copilot-previous)",
        { silent = true }
      )
    end,
  },

  -- Floating terminal
  "voldikss/vim-floaterm",

  -- Trouble - Nicely formatted quickfix and diagnostics list
  {
    "folke/trouble.nvim",
    opts = {
      height = 20,
      auto_preview = false,
      action_keys = {
        toggle_fold = { "zA", "za", "<Space>" },
        jump_close = { "<cr>" }, -- Use <Tab> to jump without closing
      },
    },
  },

  -- which-key
  { "folke/which-key.nvim", config = true },

  -- Leap.nvim - Neovim's answer to the mouse, quick on-screen navigation
  {
    "ggandor/leap.nvim",
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "å", "<Plug>(leap-forward-to)")
      vim.keymap.set({ "n", "x", "o" }, "Å", "<Plug>(leap-backward-to)")
      vim.keymap.set({ "n", "x", "o" }, "gå", "<Plug>(leap-cross-window)")
    end,
  },

  -- nvim-tree.lua
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      "ryanoasis/vim-devicons",
      "kyazdani42/nvim-web-devicons",
    },
    config = setup_file("nvim_tree"),
  },

  -- Mason - Package manager for LSPs, auto-formatters etc.
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
  },

  -- Lazygit integration
  { "kdheepak/lazygit.nvim", command = "LazyGit" },

  -- =============
  -- === Bling ===
  -- =============

  -- Notification popups
  {
    "rcarriga/nvim-notify",
    dependencies = {
      "nvim-telescope/telescope.nvim", -- For :Telescope notify
    },
    config = function()
      local notify = require("notify")

      notify.setup({
        stages = "slide",
      })

      vim.notify = notify
    end,
  },

  -- Git indicators in the gutter
  { "lewis6991/gitsigns.nvim", config = true },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-lua/lsp-status.nvim", -- LSP status component
      "SmiteshP/nvim-navic", -- Code position breadcrumbs status component
    },
    config = setup_file("lualine"),
  },

  -- Floating scrollbar
  { "dstein64/nvim-scrollview", config = true },

  -- Indentation lines
  {
    "lukas-reineke/indent-blankline.nvim",
    -- mod = "indent_blankline",
    opts = {
      show_current_context = true,
      -- show_current_context_start = true,
      char = "▎",
      max_indent_increase = 1,
    },
  },

  -- Fancy colorcolumn (shows gradually, goes red when reached)
  {
    "Bekaboo/deadcolumn.nvim",
    opts = {
      modes = { "i", "ic", "ix", "R", "Rc", "Rx", "Rv", "Rvc", "Rvx", "n" },
    },
  },

  -- ========================
  -- === Lancuage support ===
  -- ========================

  -- Python - Black auto-formatting
  "psf/black",

  -- SystemD - Syntax highlighting
  "wgwoods/vim-systemd-syntax",

  -- Markdown - Live preview server
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },

  {
    "mzlogin/vim-markdown-toc",
    commit = "7ec05df27b4922830ace2246de36ac7e53bea1db",
  },

  -- Polar - Authorization DSL
  "osohq/polar.vim",

  -- Sway config files
  "terminalnode/sway-vim-syntax",

  -- Kitty config files
  "fladson/vim-kitty",

  -- eww config files (yuck)
  "elkowar/yuck.vim",

  -- Hyprlang config files
  "theRealCarneiro/hyprland-vim-syntax",

  -- =====================
  -- === Color schemes ===
  -- =====================

  -- Color schemes
  --"rakr/vim-one", -- One theme (dark and light)
  --"tomasr/molokai", -- Molokai
  --"arcticicestudio/nord-vim", -- Nord
  --"cocopon/iceberg.vim", -- Iceberg
  --"morhetz/gruvbox", -- Gruvbox
  --"lifepillar/vim-gruvbox8", -- Gruvbox (Simplified and optimized)
  ---- "ayu-theme/ayu-vim",        -- Ayu
  --"Shatur/neovim-ayu", -- Ayu (Optimized for Neovim)
  --"folke/tokyonight.nvim", -- TokyoNight
  --"dracula/vim", -- Dracula
  --"NLKNguyen/papercolor-theme", -- PaperColor
  "EdenEast/nightfox.nvim", -- Nightfox
  { "catppuccin/nvim", name = "catppuccin" }, -- Catppuccin
})
