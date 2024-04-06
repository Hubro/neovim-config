return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "ghostbuster91/nvim-next",
  },
  setup = function()
    local parsers = require("nvim-treesitter.parsers")
    local configs = parsers.get_parser_configs()



    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      auto_install = true,

      ensure_installed = {
        "bash",
        "hyprlang",
        "javascript",
        "nix",
        "python",
        "robot",
        "tsx",
        "typescript",
        "yaml",
        "yang",
      },

      highlight = {
        enable = true,
        -- Can also enable/disable for specific languages
        -- enable = { "python" },
        -- disable = { "c", "rust" },

        -- Highlighting is currently kinda broken for some languages:
        disable = { "gitcommit" },
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<A-9>",
          node_incremental = "<A-9>",
          -- scope_incremental = "<C-l>",
          node_decremental = "<A-8>",
        },
      },

      indent = {
        enable = true,

        -- The indent expressions for some languages are complete shit
        disable = { "svelte", "php", "ssh_config", "yaml" },
      },

      autotag = {
        enable = true,
        filetypes = {
          "astro",
          "html",
          "xml",
          "javascript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          include_surrounding_whitespace = false,

          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@comment.outer",
            ["ic"] = "@comment.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
          },

          selection_modes = {},
        },

        swap = {
          enable = true,
          swap_next = {
            ["<leader>+"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>-"] = "@parameter.inner",
          },
        },
      },

      -- I'm defining all textobject moves through nvim_text, which makes them
      -- repeatable
      nvim_next = {
        enable = true,

        textobjects = {
          move = {
            -- enable = true,
            -- set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
            },
          },
        },
      },
    })

    -- =======================
    -- === Query overrides ===
    -- =======================

    if parsers.has_parser("python") then
      vim.treesitter.query.set(
        "python",
        "folds",
        [[
          (function_definition (block) @fold)
          (class_definition (block) @fold)
        ]]
      )
    end

    if parsers.has_parser("yang") then
      vim.treesitter.query.set(
        "yang",
        "folds",
        [[
          (statement
            (statement_keyword "grouping")
            (block) @fold)

          (statement
            (statement_keyword "container")
            (block) @fold)

          (statement
            (statement_keyword "list")
            (block) @fold)
        ]]
      )
    end

    if parsers.has_parser("rust") then
      vim.treesitter.query.set(
        "rust",
        "folds",
        [[
          (function_item (block) @fold)
          (struct_item (field_declaration_list) @fold)
        ]]
      )
    end

    if parsers.has_parser("astro") then
      vim.treesitter.query.set(
        "astro",
        "injections",
        [[
          ((script_element
            (raw_text) @injection.content)
           (#set! injection.language "javascript"))

          ((style_element
            (raw_text) @injection.content)
           (#set! injection.language "css"))

          ((frontmatter
             (raw_text) @injection.content)
           (#set! injection.language "typescript"))

          ((interpolation
             (raw_text) @injection.content)
           (#set! injection.language "tsx"))
        ]]
      )
    end
  end
}
