if lsp_is_configured then
  return
end

_G.lsp_is_configured = true

local success, lspconfig = pcall(require, "lspconfig")

-- Don't bother crashing loudly if lspconfig isn't installed
if success then
  local lspconfig_configs = require("lspconfig.configs")
  local lsputil = require("lspconfig.util")

  local lsp_status = require("lsp-status")

  -- Globally disables dianostics for language servers!
  --vim.lsp.handlers["textDocument/publishDiagnostics"] = function () end

  -- Handler for when a buffer is connected to a language server
  --
  -- This function is defined globally so it can be reused in local config
  -- files (.nvimrc)
  --
  _G.lsp_on_attach = function(client, bufnr)
    -- Give lsp-status a reference to the client
    lsp_status.on_attach(client)

    local function map(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = { noremap = true, silent = true }

    --map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    map("n", "gd", "<cmd>Trouble lsp_definitions<CR>", opts)
    map("n", "gD", "<cmd>Trouble lsp_type_definitions<CR>", opts)
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    map("n", "gr", "<cmd>Trouble lsp_references<CR>", opts)
    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    map("n", "<Leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    -- map('n', '(', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    -- map('n', ')', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  end

  -- {{{ Custom LSP configs

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
          pythonpath = (vim.env.PYTHONPATH and vim.split(vim.env.PYTHONPATH, ":") or { "" }),
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
      cmd = {
        "/usr/bin/node",
        "/opt/vscode-home-assistant/out/server/server.js",
        "--stdio",
      },
      filetypes = { "yaml" },
      root_dir = lsputil.root_pattern("configuration.yaml"),
      settings = {},
    },
  }

  -- }}}

  -- Default setup config for all LSP servers
  lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    autostart = true,
    on_attach = _G.lsp_on_attach,
  })

  lspconfig.yang_lsp.setup({
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

  lspconfig.robot_lsp.setup({})
  lspconfig.homeassistant.setup({})
  -- lspconfig.pylsp.setup {}
  lspconfig.pyright.setup({})
  lspconfig.tsserver.setup({})
  lspconfig.svelte.setup({})
  lspconfig.rust_analyzer.setup({})
  lspconfig.elmls.setup({})
  lspconfig.astro.setup({})
  lspconfig.tailwindcss.setup({})

  -- cssls requires snippet support
  local cssls_capabilities = vim.lsp.protocol.make_client_capabilities()
  cssls_capabilities.textDocument.completion.completionItem.snippetSupport = true
  lspconfig.cssls.setup({
    capabilities = cssls_capabilities,
  })

  -- Allow projects to define a post-LSP hook for project specific LSP config
  if _G.project_hook_lsp then
    project_hook_lsp()
  end
end
