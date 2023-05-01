if lsp_is_configured then
  return
end

_G.lsp_is_configured = true

local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig.configs")
local lsputil = require("lspconfig.util")

local lsp_status = require("lsp-status")
local navic = require("nvim-navic")

-- Neodev must be set up before lspconfig
require("neodev").setup({})

-- Globally disables dianostics for language servers!
--vim.lsp.handlers["textDocument/publishDiagnostics"] = function () end

-- Handler for when a buffer is connected to a language server
--
-- This function is defined globally so it can be reused in local config
-- files (.nvimrc)
--
_G.lsp_on_attach = function(client, bufnr)
  -- Setup LSP-based plugins
  lsp_status.on_attach(client)

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  -- The Ruff LSP only provides diagnostics, let's not set any key bindings
  if client.name == "ruff" then
    return
  end

  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local opts = { noremap = true, silent = true }

  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  map("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  map("n", "gr", "<cmd>Trouble lsp_references<CR>", opts)
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  map("n", "L", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  map("n", "<Leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  map("n", "<Leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

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
lspconfig.util.default_config =
  vim.tbl_extend("force", lspconfig.util.default_config, {
    autostart = true,
    on_attach = _G.lsp_on_attach,
  })

lspconfig.yang_lsp.setup({
  on_attach = _G.lsp_on_attach,
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

local servers_we_want = {
  "robot_lsp",
  "homeassistant",
  -- {
  --   "pylsp",
  --   {
  --     settings = {
  --       pylsp = {
  --         plugins = {
  --           autopep8 = { enabled = false },
  --           jedi_completion = { enabled = true },
  --           jedi_definition = { enabled = true },
  --           jedi_hover = { enabled = true },
  --           jedi_references = { enabled = true },
  --           jedi_signature_help = { enabled = true },
  --           jedi_symbols = { enabled = true },
  --           mccabe = { enabled = false },
  --           pycodestyle = { enabled = false },
  --           pydocstyle = { enabled = false },
  --           pyflakes = { enabled = false },
  --           pylint = { enabled = false },
  --           rope_autoimport = { enabled = true },
  --           yapf = { enabled = false },
  --         },
  --       },
  --     },
  --   },
  -- },
  {
    "pyright",
    {
      settings = {
        python = {
          analysis = {
            diagnosticMode = "off",
            typeCheckingMode = "off",
          },
        },
      },
    },
  },
  "tsserver",
  "svelte",
  "rust_analyzer",
  "elmls",
  "astro",
  { "cssls", { capabilities = cssls_capabilities } },
  "tailwindcss",
  "ruff_lsp",
  {
    "lua_ls",
    { settings = { Lua = { completion = { callSnipper = "Replace" } } } },
  },
}

for _, server_name in pairs(servers_we_want) do
  local custom_server_config

  if type(server_name) == "table" then
    custom_server_config = server_name[2]
    server_name = server_name[1]
  else
    custom_server_config = {}
  end

  local current_lspconfig = lspconfig[server_name]

  -- Only try to set up the lsp client if the executable exists, otherwise nvim will whine
  if
    vim.fn.executable(current_lspconfig.document_config.default_config.cmd[1])
    == 1
  then
    current_lspconfig.setup(
      vim.tbl_extend(
        "force",
        lspconfig.util.default_config,
        custom_server_config
      )
    )
  end
end

-- Allow projects to define a post-LSP hook for project specific LSP config
if _G.project_hook_lsp then
  project_hook_lsp()
end
