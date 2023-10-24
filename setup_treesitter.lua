local parsers = require("nvim-treesitter.parsers")
local configs = parsers.get_parser_configs()

require("nvim-next.integrations").treesitter_textobjects()

---@diagnostic disable-next-line: inject-field
configs.hypr = {
  install_info = {
    url = "https://github.com/luckasRanarison/tree-sitter-hypr.git",
    files = { "src/parser.c" },
    branch = "0e19dd13a3751d2e00285917c5620eb79f470ac5",
  },
  filetype = "hypr",
}

---@diagnostic disable-next-line: inject-field
configs.nu = {
  install_info = {
    url = "https://github.com/LhKipp/tree-sitter-nu.git",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "main",
  },
  filetype = "nu",
}

---@diagnostic disable-next-line: inject-field
configs.just = {
  install_info = {
    url = "https://github.com/IndianBoy42/tree-sitter-just",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
  },
  filetype = "just",
}

--
--
-- configs.yang = {
--     install_info = {
--         url = "~/Dropbox/projects/tree-sitter-yang",
--         files = { "src/parser.c" }
--     },
--     filetype = "yang",
-- }

-- local ts_parsers = require("nvim-treesitter.parsers")
-- local configs = ts_parsers.get_parser_configs()
--
-- configs.robot = {
--   install_info = {
--     url = "~/projects/tree-sitter-robot",
--     files = { "src/parser.c" },
--     generate_requires_npm = false,
--     required_generate_from_grammar = false,
--   },
--   filetype = "robot",
-- }

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

-- vim.treesitter.query.set(
--   "robot",
--   "indents",
--   [[
-- (section_header) @indent.zero
-- (keyword_definition (name) @indent.zero)
-- (keyword_definition (name) @indent.begin)
-- (test_case_definition (name) @indent.zero)
-- (test_case_definition (name) @indent.begin)
--   ]]
-- )

-- vim.treesitter.query.set(
--   "robot",
--   "highlights",
--   [[
-- (comment) @comment

-- (section_header) @keyword
-- (extra_text) @comment

-- (setting_statement) @keyword

-- (variable_definition (variable_name) @variable)

-- (keyword_definition (name) @function)
-- (keyword_definition (body (keyword_setting) @keyword))

-- (test_case_definition (name) @property)

-- (keyword_invocation (keyword) @function.call)
-- (ellipses) @punctuation.delimiter

-- (argument (text_chunk) @string)
-- (argument (scalar_variable) @variable)
-- (argument (list_variable) @variable)
-- (argument (dictionary_variable) @variable)
-- (argument (inline_python_expression) @string.special)

-- (ellipses) @punctuation.delimiter

-- ; Control structures
-- (for_statement
--   "FOR" @repeat
--   "END" @repeat)
-- (for_statement (in "IN" @repeat))
-- (for_statement (in_range "IN RANGE" @repeat))
-- (for_statement (in_enumerate "IN ENUMERATE" @repeat))
-- (for_statement (in_zip "IN ZIP" @repeat))

-- (while_statement
--   "WHILE" @repeat
--   "END" @repeat)

-- (break_statement) @repeat
-- (continue_statement) @repeat

-- (if_statement
--   "IF" @conditional
--   "END" @conditional)
-- (if_statement (elseif_statement "ELSE IF" @conditional))
-- (if_statement (else_statement "ELSE" @conditional))

-- (try_statement
--   "TRY" @exception
--   "END" @exception)
-- (try_statement (except_statement "EXCEPT" @exception))
-- (try_statement (else_statement "ELSE" @exception))
-- (try_statement (finally_statement "FINALLY" @exception))
-- ]]
-- )


-- configs.jsonnet = {
--   install_info = {
--     url = "https://github.com/sourcegraph/tree-sitter-jsonnet",
--     files = { "src/parser.c", "src/scanner.c" },
--   },
--   filetype = "jsonnet",
-- }

---@diagnostic disable-next-line: missing-fields
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

  -- Playground is deprecated, the functionality is now built-in,
  -- see :InspectTree
  --
  -- playground = {
  --   enable = true,
  --   disable = {},
  --   updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
  --   persist_queries = false, -- Whether the query persists across vim sessions
  --   keybindings = {
  --     toggle_query_editor = "o",
  --     toggle_hl_groups = "i",
  --     toggle_injected_languages = "t",
  --     toggle_anonymous_nodes = "a",
  --     toggle_language_display = "I",
  --     focus_language = "f",
  --     unfocus_language = "F",
  --     update = "R",
  --     goto_node = "<cr>",
  --     show_help = "?",
  --   },
  -- },

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

-- vim.treesitter.query.set(
--   "python",
--   "folds",
--   [[
--   (function_definition (block) @fold)
--   (class_definition (block) @fold)
-- ]]
-- )

-- vim.treesitter.query.set(
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

-- vim.treesitter.query.set(
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

-- vim.treesitter.query.set(
--   "rust",
--   "folds",
--   [[
--   (function_item (block) @fold)
--   (struct_item (field_declaration_list) @fold)
-- ]]
-- )

-- vim.treesitter.query.set("jsonnet", "highlights", [[
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
