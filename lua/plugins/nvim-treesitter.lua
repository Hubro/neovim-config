return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    "windwp/nvim-ts-autotag",
    "ghostbuster91/nvim-next",
  },
  lazy = false,
  config = function()
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

    ---@diagnostic disable-next-line: missing-parameter
    vim.treesitter.query.add_directive(
      "prefix!",
      ---comment
      ---@param match table<integer,TSNode>
      ---@param pattern integer
      ---@param bufnr integer
      ---@param predicate any[]
      ---@param metadata table
      function(match, pattern, bufnr, predicate, metadata)
        local _, match_index, field, prefix_text = unpack(predicate)

        local node = match[match_index]

        if not node then
          return
        end

        if not metadata[match_index] then
          metadata[match_index] = {}
        end

        if not metadata[match_index][field] then
          metadata[match_index][field] = vim.treesitter.get_node_text(node, bufnr)
        end

        metadata[match_index][field] = prefix_text .. metadata[match_index][field]
      end
    )

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.xonsh = {
      install_info = {
        url = "https://github.com/FoamScience/tree-sitter-xonsh",
        files = { "src/parser.c", "src/scanner.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
        branch = "main",                             -- default branch in case of git repo if different from master
        generate_requires_npm = true,                -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = true,       -- if folder contains pre-generated src/parser.c
      },
      filetype = "xonsh",                            -- if filetype does not match the parser name
    }

    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      auto_install = true,

      ensure_installed = {
        "bash",
        "hyprlang",
        "javascript",
        "markdown",
        "nix",
        "python",
        "robot",
        "tsx",
        "toml",
        "typescript",
        "vimdoc",
        "xml",
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
        disable = { "svelte", "php", "ssh_config", "yaml", "python" },
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
          include_surrounding_whitespace = true,

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

        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            -- ["]c"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            -- ["[c"] = "@class.outer",
          },
        },

        swap = {
          enable = true,
          -- swap_next = {
          --   ["<leader>+"] = "@parameter.inner",
          -- },
          -- swap_previous = {
          --   ["<leader>-"] = "@parameter.inner",
          -- },
        },
      },

      -- I'm defining all textobject moves through nvim_next, which makes them
      -- repeatable
      -- nvim_next = {
      --   enable = true,

      --   textobjects = {
      --     move = {
      --       enable = true,
      --       set_jumps = true,
      --       goto_next_start = {
      --         ["]f"] = "@function.outer",
      --         ["<leader>gnf"] = "@function.outer",
      --       },
      --       goto_previous_start = {
      --         ["[f"] = "@function.outer",
      --       },
      --     },
      --   },
      -- },
    })
  end
}
