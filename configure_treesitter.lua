
--local configs = require("nvim-treesitter.parsers").get_parser_configs()
--
-- configs.yang = {
--     install_info = {
--         url = "~/Dropbox/projects/tree-sitter-yang",
--         files = { "src/parser.c" }
--     },
--     filetype = "yang",
-- }
--

vim.treesitter.set_query("python", "folds", [[
  (function_definition (block) @fold)
  (class_definition (block) @fold)
]])

vim.treesitter.set_query("yang", "folds", [[
  (statement
    (statement_keyword "grouping")
    (block) @fold)

  (statement
    (statement_keyword "container")
    (block) @fold)

  (statement
    (statement_keyword "list")
    (block) @fold)
]])

require("nvim-treesitter.configs").setup {
  -- Value can be "all", "maintained" (parsers with maintainers), or a
  -- list of languages
  ensure_installed = {
    -- "abnf",
    "bash",
    "c",
    "css",
    "go",
    "graphql",
    "html",
    "java",
    "javascript",
    "lua",
    "php",
    "python",
    "query",
    "regex",
    "ruby",
    "rust",
    "scala",
    "scss",
    "svelte",
    "toml",
    "typescript",
    "vue",
    "yaml",
    "yang",
  },

  highlight = {
    enable = true,
    -- Can also enable/disable for specific languages
    -- enable = { "python" },
    -- disable = { "c", "rust" },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<A-9>",
      node_incremental = "<A-9>",
      -- scope_incremental = "<C-l>",
      node_decremental = "<A-8>",
    }
  },

  indent = {
    enable = true,
    disable = { "python" }   -- The indent expression for Python is broken
  },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
