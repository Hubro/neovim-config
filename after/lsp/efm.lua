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
  lintCommand = "nix run nixpkgs#shellcheck -- -s bash -f gcc -x -",
  lintSource = "shellcheck",
  lintStdin = true,
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
  env = { "http_proxy=", "HTTP_PROXY=", "https_proxy=", "HTTPS_PROXY=" },
}

return {
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
          lintIgnoreExitCode = true,
          lintFormats = {
            "%f:%l:%c: %trror: %m",
            "%f:%l:%c: %tarning: %m",
            "%f:%l:%c: %tote: %m",
          },
          lintSource = "mypy",
          lintWorkspace = true,
          lintOnSave = true,
          lintOnOpen = true,
          rootMarkers = { "mypy.ini" },
        }
      }
    },
  },
}
