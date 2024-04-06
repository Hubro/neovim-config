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

  -- My own projects plugin, of course
  {
    name = "nvim-projects",
    dir = "~/projects/nvim-projects",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "rcarriga/nvim-notify",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      init_filename = ".nvimrc.lua",
      project_dirs = {
        "~/projects",
        "~/Dropbox/Projects",
        "~/Dropbox/Avesta/Inhouse projects",
        "~/Dropbox/Avesta Projects",
        "~/Dropbox/Telia/src/github",
      },
      after_jump = function(_)
        vim.cmd("NeoTreeShow")
        vim.cmd([[ exec "normal \<c-w>\<c-w>" ]])
      end,
    },
  },

  -- My own splitrun plugin, of course!
  --
  -- Runs a command and puts the result in a new split
  {
    name = "nvim-splitrun",
    dir = "~/projects/nvim-splitrun",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      "ghostbuster91/nvim-next",
    },
    config = setup_file("treesitter"),
    -- setup = function()
    --   vim.cmd[[ runtime setup_treesitter.lua ]]
    -- end
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "SmiteshP/nvim-navic", -- Code position breadcrumbs status component
      "folke/neodev.nvim",   -- Lua LSP overrides for working with Neovim
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
  --
  -- This plugin is fucking awesome, but because of a bug, it ruins repeating
  -- actions with motions like "df".
  --
  -- Ref: https://github.com/ghostbuster91/nvim-next/issues/14
  --
  {
    "ghostbuster91/nvim-next",
    enabled = false,
    config = function()
      local builtins = require("nvim-next.builtins")

      require("nvim-next").setup({
        default_mappings = {
          -- repeat_style = "directional", -- Overrides ; and ,
          repeat_style = "original", -- Overrides ; and ,
        },
        items = {
          builtins.f,
          builtins.t,
        },
      })
    end,
  },

  -- Automatically close quotes and parentheses
  {
    "jiangmiao/auto-pairs",
    init = function()
      vim.g.AutoPairsShortcutToggle = ""
      vim.g.AutoPairsShortcutFastWrap = "<M-w>"
      vim.g.AutoPairsShortcutJump = ""
      vim.g.AutoPairsShortcutBackInsert = "<M-b>"
      vim.g.AutoPairsMultilineClose = 0 -- Never auto jump to next line
      vim.g.AutoPairsMapCh = 0          -- Don't map to <C-h>

      -- Center the viewport when pressing <CR> when near edge of viewport
      vim.g.AutoPairsCenterLine = 1
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
      link_tree_to_folds = false,
      link_folds_to_tree = false,
      show_guides = true,
      nerd_font = true,
      filter_kind = {
        yang = false,  -- In YANG, show all symbol types
        robot = false, -- In Robot Framework, show all symbol types
      }
    },
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

  -- ========================
  -- === Nice extra tools ===
  -- ========================

  -- rust-tools.nvim - Auto-setup of LSP and debugging + nice commands
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
    },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          ---@diagnostic disable-next-line: undefined-field
          _G.lsp_on_attach(client, bufnr) -- Defined in setup_lsp.lua

          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "K", "<cmd>RustHoverActions<CR>", opts)
          vim.keymap.set("n", "<Leader>rr", "<cmd>RustRunnables<CR>", opts)
          vim.keymap.set("n", "<Leader>re", "<cmd>RustExpandMacro<CR>", opts)
          vim.keymap.set("n", "<Leader>rc", "<cmd>RustCargo<CR>", opts)
        end,
      },
      tools = {
        on_initialized = function()
          require("rust-tools").inlay_hints.enable()
        end,
        inlay_hints = {
          -- only_current_line = true,
          -- parameter_hints_prefix = "<-",
          -- other_hints_prefix = "=>",
        },
      },
    },
  },

  -- Copilot (Remember to run ":Copilot setup" to sign in)
  {
    "github/copilot.vim",
    init = function()
      -- Keep copilot disabled, only invoke explicitly
      vim.g.copilot_filetypes = { ["*"] = false }
      vim.g.copilot_no_tab_map = true

      local suggest = function()
        require("cmp").abort() -- Hide cmp completion window
        vim.fn["copilot#Suggest"]()
      end

      local accept_word = function()
        vim.schedule(suggest)
        return vim.fn["copilot#AcceptWord"]()
      end

      local accept_line = function()
        vim.schedule(suggest)
        return vim.fn["copilot#AcceptLine"]()
      end

      vim.keymap.set("i", "<A-p>", suggest, { silent = true })
      vim.keymap.set("i", "<C-e>", 'copilot#Accept("")', { expr = true, replace_keycodes = false })
      vim.keymap.set("i", "<A-l>", accept_word, { expr = true, remap = true, replace_keycodes = true })
      vim.keymap.set("i", "<A-h>", accept_line, { expr = true, remap = true, replace_keycodes = true })
      vim.keymap.set("n", "<Leader>cp", ":Copilot panel<CR>", { silent = true })
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
        toggle_fold = { "zA", "za" },
        jump = { "<tab>" },
        jump_close = { "<cr>" }, -- Use <Tab> to jump without closing
      },
    },
  },

  -- which-key
  { "folke/which-key.nvim",   config = true },

  -- Leap.nvim - Neovim's answer to the mouse, quick on-screen navigation
  {
    "ggandor/leap.nvim",
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "å", "<Plug>(leap-forward-to)")
      vim.keymap.set({ "n", "x", "o" }, "Å", "<Plug>(leap-backward-to)")
      vim.keymap.set({ "n", "x", "o" }, "gå", "<Plug>(leap-cross-window)")
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
    opts = {
      window = {
        mappings = {
          ["<c-x>"] = "open_split",
          ["<m-x>"] = "split_with_window_picker",
          ["<c-v>"] = "open_vsplit",
          ["<m-v>"] = "vsplit_with_window_picker",
          ["<c-t>"] = "open_tabnew",
          ["<bs>"] = "close_node",
          ["z"] = "",
          ["zO"] = "expand_all_nodes",
          ["zM"] = "close_all_nodes",
        },
      },
      filesystem = {
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false, -- Toggle with H
          hide_dotfiles = true,
          hide_gitignored = true,
          always_show = {
            ".github",
            ".gitignore",
            ".dockerignore",
          },
        },
        window = {
          mappings = {
            ["/"] = "", -- Disable the annoying filter function
          }
        }
      },
      default_component_configs = {
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        git_status = {
          symbols = {
            -- Change type
            added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted   = "✖", -- this can only be used in the git_status source
            renamed   = "󰁕", -- this can only be used in the git_status source

            -- Status type
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
    },
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
    priority = 1000, -- Other plugins might depend on packages installed by mason
    lazy = false,
  },

  -- Lazygit integration
  { "kdheepak/lazygit.nvim",  command = "LazyGit" },

  -- =============
  -- === Bling ===
  -- =============

  -- Improves default vim interfaces
  { "stevearc/dressing.nvim", opts = {} },

  {
    "karb94/neoscroll.nvim",
    enabled = vim.g.neovide == nil,
    opts = {
      hide_cursor = true,
      easing_function = "quadratic",
      pre_hook = function()
        -- require("treesitter-context").disable()
      end,
      post_hook = function()
        -- require("treesitter-context").enable()
      end,
    },
    config = function(_, opts)
      require("neoscroll").setup(opts)
      require("neoscroll.config").set_mappings({
        ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "150" } },
        ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "150" } },
        ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "200" } },
        ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "200" } },
      })
    end
  },

  {
    -- Annoying in combination with auto-formatting on save
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = false,
    },
  },

  -- Notification popups
  {
    "rcarriga/nvim-notify",
    dependencies = {
      "nvim-telescope/telescope.nvim", -- For :Telescope notify
    },
    config = function()
      local notify = require("notify")

      ---@diagnostic disable-next-line: missing-fields
      notify.setup({
        stages = "slide",
      })

      local banned_messages = {
        "No information available",
      }

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.notify = function(msg, ...)
        for _, banned in ipairs(banned_messages) do
          if msg == banned then
            return
          end

          return notify(msg, ...)
        end
      end
    end,
  },

  -- Git indicators in the gutter
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "ghostbuster91/nvim-next" },
    config = function()
      -- local next_integration = require("nvim-next.integrations").gitsigns

      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          -- local next = next_integration(gs)

          -- vim.keymap.set(
          --   "n",
          --   "]c",
          --   next.next_hunk,
          --   { buffer = bufnr, desc = "Next modified hunk" }
          -- )
          -- vim.keymap.set(
          --   "n",
          --   "[c",
          --   next.prev_hunk,
          --   { buffer = bufnr, desc = "Previous modified hunk" }
          -- )
        end,
      })
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "linrongbin16/lsp-progress.nvim",
      "SmiteshP/nvim-navic",        -- Code position breadcrumbs status component
      "ofseed/copilot-status.nvim", -- Shows what Copilot is up to
    },
    config = setup_file("lualine"),
  },

  {
    "linrongbin16/lsp-progress.nvim",
    opts = {
      spinner = { "", "", "", "", "", "" },
      spin_update_time = 75,
    },
  },

  -- Floating scrollbar
  { "dstein64/nvim-scrollview",     config = true },

  -- Indentation lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      -- show_current_context_start = true,
      indent = {
        char = "▏",
        -- char = "┊",
        -- char = "▍",
      },
      scope = {
        char = "▎",
        show_start = false,
        show_end = false,
        exclude = {
          language = {
            -- ...
          }
        }
      }
    },
  },

  -- Fancy colorcolumn (shows gradually, goes red when reached)
  {
    "Bekaboo/deadcolumn.nvim",
    enabled = false,
    branch = "dev",
    opts = {
      modes = { "i", "R", "c", "n", "v" },
      -- This custom scope function makes colorcolumn always visible if any
      -- currently visible line crosses a colorcolumn. Otherwise, the
      -- colorcolumn is only displayed when the currently focused line
      -- approaches it.
      scope = function()
        local lines = vim.api.nvim_buf_get_lines(
          0,
          vim.fn.line("w0") - 1,
          vim.fn.line("w$"),
          false
        )
        local longest_on_screen_line =
            math.max(unpack(vim.tbl_map(vim.fn.strdisplaywidth, lines)))

        local cc = require("deadcolumn.utils").resolve_cc(vim.wo.cc)

        if cc ~= nil and longest_on_screen_line >= cc then
          return longest_on_screen_line
        else
          return vim.fn.strdisplaywidth(vim.api.nvim_get_current_line())
        end
      end,
    },
  },

  -- ========================
  -- === Lancuage support ===
  -- ========================

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
  --"ayu-theme/ayu-vim",        -- Ayu
  --"Shatur/neovim-ayu", -- Ayu (Optimized for Neovim)
  --"folke/tokyonight.nvim", -- TokyoNight
  --"dracula/vim", -- Dracula
  --"NLKNguyen/papercolor-theme", -- PaperColor
  "EdenEast/nightfox.nvim",                                                          -- Nightfox
  { "catppuccin/nvim",       name = "catppuccin" },                                  -- Catppuccin
  { "rebelot/kanagawa.nvim", opts = { dimInactive = true, terminalColors = true } }, -- Kanagawa
  "AlexvZyl/nordic.nvim",                                                            -- Nordic
})
