-- local configs = require("nvim-treesitter.parsers").get_parser_configs()
--
-- configs.yang = {
--     install_info = {
--         url = "~/Dropbox/projects/tree-sitter-yang",
--         files = { "src/parser.c" }
--     },
--     filetype = "yang",
-- }

local success, ts_parsers = pcall(require, "nvim-treesitter.parsers")

if success then
  local configs = ts_parsers.get_parser_configs()

  configs.robot = {
    install_info = {
      url = "~/Dropbox/Projects/tree-sitter-robot",
      files = { "src/parser.c" },
      generate_requires_npm = false,
      required_generate_from_grammar = false,
    },
    filetype = "robot",
  }

  -- configs.jsonnet = {
  --   install_info = {
  --     url = "https://github.com/sourcegraph/tree-sitter-jsonnet",
  --     files = { "src/parser.c", "src/scanner.c" },
  --   },
  --   filetype = "jsonnet",
  -- }

  require("nvim-treesitter.configs").setup({
    sync_install = true,
    auto_install = true,

    highlight = {
      enable = true,
      -- Can also enable/disable for specific languages
      -- enable = { "python" },
      -- disable = { "c", "rust" },

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
      disable = { "svelte", "php" },
    },

    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },

    autotag = {
      enable = true,
      filetypes = {
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

      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]c"] = "@function.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["]c"] = "@function.outer",
        },
      },
    },
  })

  -- vim.treesitter.set_query(
  --   "python",
  --   "folds",
  --   [[
  --   (function_definition (block) @fold)
  --   (class_definition (block) @fold)
  -- ]]
  -- )

  -- vim.treesitter.set_query(
  --   "yang",
  --   "folds",
  --   [[
  --   (statement
  --     (statement_keyword "grouping")
  --     (block) @fold)

  --   (statement
  --     (statement_keyword "container")
  --     (block) @fold)

  --   (statement
  --     (statement_keyword "list")
  --     (block) @fold)
  -- ]]
  -- )

  -- vim.treesitter.set_query(
  --   "yang",
  --   "indents",
  --   [[
  --   (module) @indent
  --   (submodule) @indent
  --   (statement) @indent
  --   (extension_statement) @indent
  --   (statement ";" @indent_end)
  --   (extension_statement ";" @indent_end)
  --   (block "}" @indent_end @branch)

  --   ((string) @aligned_indent
  --    (#set! "delimiter" "\"\""))
  -- ]]
  -- )

  -- vim.treesitter.set_query(
  --   "robot",
  --   "highlights",
  --   [[
  --   (comment) @comment
  --   (ellipses) @punctuation.delimiter

  --   (section_header) @keyword
  --   (extra_text) @comment

  --   (setting_statement) @keyword

  --   (variable_definition (variable_name) @variable)

  --   (keyword_definition (name) @function)
  --   (keyword_definition (body (keyword_setting) @keyword))

  --   (test_case_definition (name) @property)

  --   (keyword_invocation (keyword) @function)

  --   (argument (text_chunk) @string)
  --   (argument (scalar_variable) @string.special)
  --   (argument (list_variable) @string.special)
  --   (argument (dictionary_variable) @string.special)
  -- ]]
  -- )

  -- vim.treesitter.set_query(
  --   "rust",
  --   "folds",
  --   [[
  --   (function_item (block) @fold)
  --   (struct_item (field_declaration_list) @fold)
  -- ]]
  -- )

  -- vim.treesitter.set_query("jsonnet", "highlights", [[
  --   "if" @conditional
  --   [
  --     (local)
  --     "function"
  --   ] @keyword
  --   (comment) @comment

  --   (string) @string
  --   (number) @number
  --   [
  --     (true)
  --     (false)
  --   ] @boolean

  --   (binaryop) @operator
  --   (unaryop) @operator

  --   (id) @variable
  --   (param identifier: (id) @variable.parameter)
  --   (bind function: (id) @function)
  --   (fieldname) @string.special
  --   [
  --     "["
  --     "]"
  --     "{"
  --     "}"
  --   ] @punctuation.bracket
  -- ]])
end
