return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "SmiteshP/nvim-navic", -- Code position breadcrumbs status component
    "folke/neodev.nvim",   -- Lua LSP overrides for working with Neovim
  },
  event = "VeryLazy",
  config = function()
    local lspconfig = require("lspconfig")
    local lspconfig_configs = require("lspconfig.configs")
    local lsputil = require("lspconfig.util")

    local navic = require("nvim-navic")

    -- Neodev must be set up before lspconfig
    require("neodev").setup({})

    -- Globally disables dianostics for language servers!
    --vim.lsp.handlers["textDocument/publishDiagnostics"] = function () end

    -- Handler for when a buffer is connected to a language server
    --
    local lsp_on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end

      -- The Ruff LSP only provides diagnostics, let's not set any key bindings
      if client.name == "ruff" then
        return
      end

      if client.name == "efm" then
        require("hubro.config.efm").on_attach(client, bufnr)
      end

      local function map(mode, lh, rh)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set(mode, lh, rh, opts)
      end

      -- Use nvim-next to hop to diagnostic, which makes it a repeatable motion
      -- local next_lspdiag = require("nvim-next.integrations.diagnostic")()

      map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
      map("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
      map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
      -- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
      map("n", "gr", "<cmd>Trouble lsp_references<CR>")
      map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
      map("n", "L", "<cmd>lua vim.diagnostic.open_float()<CR>")
      map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
      map("n", "<Leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>")
      map("n", "<Leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>")

      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      local next_diag, prev_diag = ts_repeat_move.make_repeatable_move_pair(
        vim.diagnostic.goto_next,
        vim.diagnostic.goto_prev
      )

      map({ "n", "x", "o" }, "]d", next_diag)
      map({ "n", "x", "o" }, "[d", prev_diag)
    end

    -- {{{ Custom LSP configs

    -- Custom config for YANG language server
    --
    lspconfig_configs.yang_lsp = {
      default_config = {
        cmd = { vim.env.HOME .. "/.local/lib/yang-lsp/bin/yang-language-server" },
        filetypes = { "yang" },
        root_dir = function(fname)
          return lsputil.root_pattern("yang.settings")(fname)
              or lsputil.find_git_ancestor(fname)

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

    -- Custom config for Robot Framework language server
    --
    lspconfig_configs.robot_lsp = {
      default_config = {
        cmd = { "robotframework_ls" },
        filetypes = { "robot" },
        root_dir = function(fname)
          return lsputil.find_git_ancestor(fname) or lsputil.path.dirname(fname)
        end,
        settings = {
          robot = {
            pythonpath = (
              vim.env.PYTHONPATH and vim.split(vim.env.PYTHONPATH, ":") or { "" }
            ),
          },
        },
      },
      docs = {
        description = [[
  TODO
      ]],
      },
    }

    -- Custom config for Home Assistant language server
    --
    lspconfig_configs.homeassistant = {
      default_config = {
        cmd = { "home-assistant-lsp", "--stdio" },
        -- cmd = {
        --   "/usr/bin/node",
        --   "/opt/vscode-home-assistant/out/server/server.js",
        --   "--stdio",
        -- },
        filetypes = { "yaml" },
        root_dir = lsputil.root_pattern("configuration.yaml"),
        settings = {},
      },
    }

    -- }}}

    -- Default setup config for all LSP servers
    lspconfig.util.default_config =
        vim.tbl_extend("force", lspconfig.util.default_config, {
          autostart = true,
          on_attach = lsp_on_attach,
        })

    lspconfig.yang_lsp.setup({
      -- on_attach = lsp_on_attach,
      capabilities = {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = false,
            },
          },
        },
      },
    })

    -- cssls requires snippet support
    local cssls_capabilities = vim.lsp.protocol.make_client_capabilities()
    cssls_capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- For some LSP servers, we only case about code actions
    local only_code_actions_handlers = {}
    for name, _ in ipairs(vim.lsp.handlers) do
      only_code_actions_handlers[name] = function() end
    end
    only_code_actions_handlers["textDocument/codeAction"] = vim.lsp.handlers["textDocument/codeAction"]

    local servers_we_want = {
      "robot_lsp",
      "homeassistant",
      {
        "pyright",
        {
          settings = {
            python = {
              analysis = {
                -- diagnosticMode = "off",
                -- typeCheckingMode = "off",
              },
            },
          },
          handlers = {
            -- ["textDocument/publishDiagnostics"] = function() end
          }
        },
      },
      {
        "pylsp",
        {
          handlers = only_code_actions_handlers,
          settings = {
            pylsp = {
              plugins = {
                "pylsp-rope"
              }
            }
          }
        }
      },
      -- "tsserver",   -- Deprecated in favor of ts_ls
      "svelte",
      -- "rust_analyzer",   -- Configured by rust-tools.nvim
      "elmls",
      "astro",
      { "cssls",       { capabilities = cssls_capabilities } },
      { "tailwindcss", { filetypes = { "astro", "svelte" } } },
      { "ruff_lsp", {
        init_options = {
          settings = {
            -- lint = { args = { "--ignore=F401" } },
            -- format = { args = { "--line-length=88" } },
          }
        }
      } },
      { "lua_ls", { settings = { Lua = { completion = { callSnippet = "Replace" } } } }, },
      -- "rnix",
      "nixd",
      { "efm",    require("hubro.config.efm").lsp_config },
    }

    for _, server_name in pairs(servers_we_want) do
      local custom_server_config

      if type(server_name) == "table" then
        custom_server_config = server_name[2]
        server_name = server_name[1]
      else
        custom_server_config = {}
      end

      local config = vim.tbl_extend(
        "force",
        lspconfig.util.default_config,
        custom_server_config
      )

      lspconfig[server_name].setup(config)
    end
  end,
}
