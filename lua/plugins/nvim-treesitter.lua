return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    "windwp/nvim-ts-autotag",
    "ghostbuster91/nvim-next",
  },
  lazy = false,
  config = function()
    local ts = require("nvim-treesitter")
    local textobjects = require("nvim-treesitter-textobjects")
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

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

    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    ts.install({
      "bash",
      "html",
      "hyprlang",
      "javascript",
      "json",
      "just",
      "markdown",
      "nix",
      "python",
      "robot",
      "rust",
      "svelte",
      "toml",
      "tsx",
      "typescript",
      "vimdoc",
      "xml",
      "yaml",
      "yang",
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreeSitterStart", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end
    })

    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = false,
        enable_rename = false,
        enable_close_on_slash = false,
      },
      per_filetype = {
        astro = { enable_close = true, enable_rename = true, },
        html = { enable_close = true, enable_rename = true, },
        xml = { enable_close = true, enable_rename = true, },
        javascript = { enable_close = true, enable_rename = true, },
        javascriptreact = { enable_close = true, enable_rename = true, },
        typescriptreact = { enable_close = true, enable_rename = true, },
        svelte = { enable_close = true, enable_rename = true, },
        vue = { enable_close = true, enable_rename = true, },
      },
    })

    textobjects.setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = true,
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require("nvim-treesitter-textobjects.select")

    local function textobject_map(lhs, capture, query_group)
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(capture, query_group or "textobjects")
      end)
    end

    textobject_map("af", "@function.outer")
    textobject_map("if", "@function.inner")
    textobject_map("ac", "@comment.outer")
    textobject_map("ic", "@comment.inner")
    textobject_map("ap", "@parameter.outer")
    textobject_map("ip", "@parameter.inner")

    local move = require("nvim-treesitter-textobjects.move")

    local function move_map(lhs, fn)
      vim.keymap.set({ "n", "x", "o" }, lhs, fn)
    end

    move_map("]f", function() move.goto_next_start("@function.outer", "textobjects") end)
    move_map("[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
  end
}
