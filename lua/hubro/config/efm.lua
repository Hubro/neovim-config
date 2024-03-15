--
-- EFM config for setup_lsp.lua
--

local M = {}

local efm_format_with_prettierd = {
  formatCommand = "nix run nixpkgs#prettierd ${INPUT}",
  formatStdin = true,
  rootMarkers = {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.js",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.mjs",
    ".prettierrc.cjs",
    ".prettierrc.toml",
  }
}

local efm_lint_with_shellcheck = {
  lintCommand = "nix run nixpkgs#shellcheck -- -f gcc -x -",
  lintSource = "shellcheck",
  lintStdin = true,
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
  env = { "http_proxy=", "HTTP_PROXY=", "https_proxy=", "HTTPS_PROXY=" },
}

M.lsp_config = {
  filetypes = {
    "sh", "bash", "zsh",
    "html", "css",
    "json", "jsonc",
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "svelte", "astro",
    "nix",
    "python",
  },
  init_options = {
    documentFormatting = true,
  },
  settings = {
    -- Probably don't want a global root marker, or auto-formatting won't
    -- work outside of Git projects. Set root markers per language instead,
    -- if necessary.
    --
    -- rootMarkers = { ".git/" },

    languages = {
      sh = {
        efm_lint_with_shellcheck,
        {
          -- Bash/sh expects tabs for indentation, using spaces breaks
          -- things like Heredoc syntax... Fuck bash
          formatCommand = "nix run nixpkgs#shfmt -- --indent 0 -ln bash",
          formatStdin = true,
          env = { "http_proxy=", "HTTP_PROXY=", "https_proxy=", "HTTPS_PROXY=" },
        }
      },
      bash = {
        efm_lint_with_shellcheck,
        {
          -- Bash/sh expects tabs for indentation, using spaces breaks
          -- things like Heredoc syntax... Fuck bash
          formatCommand = "nix run nixpkgs#shfmt -- --indent 0 -ln bash",
          formatStdin = true,
          env = { "http_proxy=", "HTTP_PROXY=", "https_proxy=", "HTTPS_PROXY=" },
        }
      },
      zsh = {
        -- Poor zsh, no tools support it... :(
      },
      javascript = { efm_format_with_prettierd },
      json = { efm_format_with_prettierd },
      jsonc = { efm_format_with_prettierd },
      typescript = { efm_format_with_prettierd },
      html = { efm_format_with_prettierd },
      css = { efm_format_with_prettierd },
      svelte = { efm_format_with_prettierd },
      astro = { efm_format_with_prettierd },
      nix = {
        {
          formatCommand = "nix run nixpkgs#alejandra -- -q -",
          formatStdin = true,
        }
      },
      python = {
        {
          lintCommand = "mypy --show-column-numbers",
          lintFormats = {
            "%f:%l:%c: %trror: %m",
            "%f:%l:%c: %tarning: %m",
            "%f:%l:%c: %tote: %m",
          },
          lintSource = "mypy",
          lintWorkspace = true,
          lintOnSave = true,
          rootMarkers = { "mypy.ini" },
        }
      }
    },
  }
}

M.on_attach = function(client, bufnr)
  local efm_ns = vim.lsp.diagnostic.get_namespace(client.id)

  local augroup = vim.api.nvim_create_augroup("efm-clear-diagnostics-buf-" .. bufnr, {})

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = augroup,
    buffer = bufnr,
    desc = "Clears diagnostics from efm-langserver when the document changes",
    callback = function()
      local diagnostics = vim.diagnostic.get(bufnr, { namespace = efm_ns })

      for _, diag in ipairs(diagnostics) do
        if diag.source == "mypy" then
          vim.diagnostic.set(efm_ns, bufnr, diagnostics, {})
        end
      end
    end
  })
end

return M
