return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "ghostbuster91/nvim-next",
  },
  lazy = false,
  config = function()
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
        "typescript",
        "vimdoc",
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
          -- swap_next = {
          --   ["<leader>+"] = "@parameter.inner",
          -- },
          -- swap_previous = {
          --   ["<leader>-"] = "@parameter.inner",
          -- },
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
  end
}
